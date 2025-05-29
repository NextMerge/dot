function zes
    #if we're inside tmux detach first
    if set -q TMUX
        tmux detach-client
    end

    set -l dirs (fd -t d -d 1 . $GITTER_DIR --exclude "Arhive git")
    set -l selected_project (printf '%s\n' $dirs | sd "$GITTER_DIR/" "" | sd "/\$" "" | fzf)
    
    if test -z $selected_project
        return 1
    end

    if tmux has-session -t $selected_project
        tmux attach-session -t $selected_project
        return 0
    end

    set -l working_dir $GITTER_DIR/$selected_project
    if test -d worktrees
        set working_dir (git_worktree_select)
    end
    
    set -l session_name $selected_project
    
    tmux new-session -s $session_name -c $working_dir
    
    tmux rename-window -t $session_name:1 editor
    tmux send-keys -t $session_name:editor "nvim" C-m

    if test -f $DOTS_DIR/tmux/zes/$selected_project.fish
        fish $DOTS_DIR/tmux/zes/$selected_project.fish $session_name
    end
    
    tmux attach-session -t $session_name
end

