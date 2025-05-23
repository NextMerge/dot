function check_docker
    if not docker ps --filter "name=sombra-db-1" --format "{{.Status}}" 2>/dev/null | grep -q "Up"
        set_color red
        echo "Docker containers are not running!"
        set_color normal
        osascript -e 'display notification "Docker containers are not running. Killing cmux session." with title "Docker Alert"'
        sleep 5
        if not docker ps --filter "name=sombra-db-1" --format "{{.Status}}" 2>/dev/null | grep -q "Up"
            zellij kill-session civalgo
            exit 1
        end
    end
end

echo "Starting OrbStack.app..."

open -jga OrbStack
sleep 5
docker start sombra-hasura-1 sombra-db-1 sombra-pubsub-1 elasticsearch sombra-pdftron-server-1 >/dev/null 2>&1
osascript -e 'display notification "Docker containers are not running. Killing cmux session." with title "Docker Alert"'


set_color cyan
echo "Watching for Docker containers..."
set_color normal

while true
    sleep 20
    check_docker
end
