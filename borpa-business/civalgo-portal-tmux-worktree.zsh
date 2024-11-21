
#!/bin/zsh

# Constants
TMUX_SESSION="civalgo"
TMUX_WINDOW="dev-docker"
TMUX_PANE="0"
TMUX_TARGET="${TMUX_SESSION}:${TMUX_WINDOW}.${TMUX_PANE}"

# Get the worktree name from first argument
WORKTREE_NAME=$1

if [ -z "$WORKTREE_NAME" ]; then
    echo "Error: No worktree name provided"
    exit 1
fi

# Check if civalgo tmux session exists
if ! tmux has-session -t $TMUX_SESSION 2>/dev/null; then
    echo "Error: No civalgo tmux session found"
    exit 1
fi

# Send Ctrl-C to stop current process
tmux send-keys -t $TMUX_TARGET C-c

# Wait a second
sleep 1

# Change directory to the worktree
tmux send-keys -t $TMUX_TARGET "cd ../${WORKTREE_NAME}" Enter

tmux send-keys -t $TMUX_TARGET "npm install && tmux wait-for -S npm-install-done" Enter

# Wait for npm install to finish
tmux wait-for npm-install-done

# Start dev server
tmux send-keys -t $TMUX_TARGET 'npm run dev' Enter

echo "Successfully switched portal dev server to worktree: ${WORKTREE_NAME}"
