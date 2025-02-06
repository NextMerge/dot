function __cmux-sombra
    if git branch --show-current | grep -q master
        git pull
        npm i
    else
        set_color cyan
        echo "Not on master branch. Skipping pull and install."
        sleep 4
    end

    set -l SUCCESS_MESSAGE "Connection to 127.0.0.1 port 5432 [tcp/postgresql] succeeded!"

    set_color cyan
    echo "Waiting for Postgres Database to be available..."
    set_color normal

    while true
        nc -zv 127.0.0.1 5432
        if test $status -eq 0
            set_color green
            echo "Postgres Database is available!"
            set_color normal
            break
        end
        sleep 3
    end

    if git branch --show-current | grep -q master
        set -l MIGRATION_DETECTED_MESSAGE "Batch [0-9]+ run: [0-9]+ migrations"
        set -l MIGRATION_ERROR_MESSAGE "migration failed with error:"

        # Capture the migration output while still displaying it
        set MIGRATION_OUTPUT (npm run db:migrate &| tee /dev/tty)
        set MIGRATION_STATUS $status

        # Check for successful migration
        if string match -rq "$MIGRATION_ERROR_MESSAGE" "$MIGRATION_OUTPUT"
            osascript -e 'display notification "Knex migration had an error!" with title "Sombra Alert"'
            return
        else if string match -rq "$MIGRATION_DETECTED_MESSAGE" "$MIGRATION_OUTPUT"
            # Migration ran successfully with changes
            osascript -e 'display notification "Database migrations were detected and completed successfully!" with title "Sombra Alert"'

            cd hasura
            hasura metadata apply --endpoint http://localhost:3011 --admin-secret secret
            cd ..
            npm run generate:gql
        end
    end

    npm run dev
end
