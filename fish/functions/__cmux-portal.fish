function __cmux-portal
    if test -f package-lock.json
        git pull
        npm i
        npm run dev
    else
        echo "Not in a git repository"
    end
end
