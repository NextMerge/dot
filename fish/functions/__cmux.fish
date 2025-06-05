set -x portal_worktree_path (git_worktree_select "$GITTER_DIR/civalgo/portal/")

if test $status -eq 1
    return 1
end

tmux send-keys "cd $portal_worktree_path" C-m

tmux split-window -v -p 30 -c $GITTER_DIR/civalgo

tmux split-window -h -t {top} -c $GITTER_DIR/civalgo/sombra

tmux send-keys -t {top-left} "__cmux-portal" C-m
tmux send-keys -t {top-right} "__cmux-sombra" C-m
tmux send-keys -t {bottom} "__cmux-killer" C-m

tmux select-window -t :1