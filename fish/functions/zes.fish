function zes
    function switch_to
        if test -z $TMUX
            tmux attach-session -t $argv[1]
        else
            tmux switch-client -t $argv[1]
        end
    end

    function has_session
        tmux list-sessions 2>/dev/null | grep -q "^$argv[1]:"
    end

    set -l selected_project
    if test (count $argv) -gt 0
        set selected_project $argv[1]
    else
        set -l dirs (fd -t d -d 1 . $GITTER_DIR --exclude "Arhive git")
        set selected_project (printf '%s\n' $dirs | sd "$GITTER_DIR/" "" | sd "/\$" "" | fzf)
    end

    if test -z $selected_project
        return 1
    end

    set -l session_name $selected_project

    if has_session $session_name
        switch_to $session_name
        return 0
    end

    set -l working_dir $GITTER_DIR/$selected_project
    if not test -d $working_dir
        echo "Directory $working_dir does not exist!"
        return 1
    end

    if test -d $working_dir/worktrees
        set working_dir (git_worktree_select $working_dir)
    end

    tmux new-session -d -s $session_name -c $working_dir

    set -l editor_window_name editor
    tmux rename-window -t $session_name:1 $editor_window_name
    tmux send-keys -t $session_name:$editor_window_name nvim C-m

    if test -f $DOTS_DIR/tmux/zes/$selected_project.fish
        fish $DOTS_DIR/tmux/zes/$selected_project.fish $session_name $editor_window_name
    end

    switch_to $session_name
end
