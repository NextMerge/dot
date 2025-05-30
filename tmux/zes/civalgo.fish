set -l session_name $argv[1]
set -l editor_window_name $argv[2]

set -x portal_worktree_path (git_worktree_select "$GITTER_DIR/civalgo/portal/")

if test $status -eq 1
    return 1
end

# create a new window
tmux new-window -t $session_name -n motors -c $portal_worktree_path

# split window into top and bottom
tmux split-window -t $session_name:motors -v -p 20 -c $GITTER_DIR/civalgo

# split top pane into left and right
tmux split-window -t $session_name:motors.1 -h -c $GITTER_DIR/civalgo/sombra

# set up Portal pane (left)
tmux send-keys -t $session_name:motors.1 "__cmux-portal" C-m

# set up Sombra pane (right)
tmux send-keys -t $session_name:motors.2 "__cmux-sombra" C-m

# set up Watcher pane (bottom)
tmux send-keys -t $session_name:motors.3 "__cmux-killer" C-m

# rename panes
tmux select-pane -t $session_name:motors.1 -T Portal
tmux select-pane -t $session_name:motors.2 -T Sombra
tmux select-pane -t $session_name:motors.3 -T Watcher

# put focus back to the editor
tmux select-window -t $session_name:$editor_window_name