function check_docker
    if not pgrep -q Docker
        set_color red
        echo "Docker.app is not running!"
        set_color normal
        osascript -e 'display notification "Docker.app is not running. Killing cmux session." with title "Docker Alert"'
        sleep 5
        if not pgrep -q Docker
            zellij kill-session civalgo
            exit 1
        end
    end
end

set_color cyan
echo "Watching Docker.app..."
set_color normal

while true
    sleep 20
    check_docker
end
