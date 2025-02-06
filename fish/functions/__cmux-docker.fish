function __cmux-docker
    open -jga Docker
    set_color cyan
    echo "Waiting for Docker.app to start..."
    set_color normal
    sleep 10
    npm run docker-start
end

