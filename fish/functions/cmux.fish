function cmux --description "Start Zellij session with civalgo configuration"
    # Check if Zellij session is already running
    if zellij ls | grep -q civalgo
        zellij attach civalgo
    else
        set -x PORTAL_WORKTREE_PATH (git_worktree_select "$GITTER_DIR/civalgo/portal/")

        if test $status -eq 1
            return 1
        end

        zellij --layout $DOTS_DIR/borpa-business/civalgo-layout.kdl
    end
end
