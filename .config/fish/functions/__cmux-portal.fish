function __cmux-portal
    set -l portal_worktree_path (git_worktree_select "$GITTER_DIR/civalgo/portal/")
    if test $status -eq 1
        return 1
    end

    cd $portal_worktree_path

    sleep 2
    if test -f pnpm-lock.yaml
        git pull
        pnpm i
        pnpm run dev
    else
        echo "Not in a git repository"
    end
end
