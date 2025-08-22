function __cmux-portal
    sleep 5
    
    if test -f pnpm-lock.yaml
        pnpm --filter portal i
        pnpm --filter portal run dev
    else
        echo "Not in a package.json repository"
    end
end
