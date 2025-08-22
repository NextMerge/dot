function cmux --description "Connect to existing cmux session or create new one with worktree selection"
    # Check if any tmux session matching "cmux/*" exists
    set -l existing_sessions (tmux list-sessions 2>/dev/null | grep "^cmux/" | head -1)
    
    if test -n "$existing_sessions"
        # Extract the session name from the first matching session
        set -l session_name (echo "$existing_sessions" | cut -d: -f1)
        echo "Connecting to existing session: $session_name"
        tmux attach-session -t "$session_name"
        return 0
    end
    
    # No existing cmux session found, prompt for worktree selection
    echo "No existing cmux session found. Please select a worktree:"
    
    set -l exo_worktree_path (git_worktree_select "$GITTER_DIR/civalgo/exo/")
    if test $status -eq 1
        echo "No worktree selected. Exiting."
        return 1
    end

    # Extract worktree name from path (last directory component)
    set -l worktree_name (basename "$exo_worktree_path")
    set -l session_name "cmux/$worktree_name"

    echo "Creating new tmux session: $session_name"

    # Create new tmux session with the first window (portal) in the worktree directory
    tmux new-session -d -s "$session_name" -n "portal" -c "$exo_worktree_path"
    
    # Send the portal command to the first window
    tmux send-keys -t "$session_name:portal" "__cmux-portal" Enter

    # Create second window (sombra) in the worktree directory
    tmux new-window -t "$session_name" -n "sombra" -c "$exo_worktree_path"
    tmux send-keys -t "$session_name:sombra" "__cmux-sombra" Enter

    # Create third window (killer) in the worktree directory
    tmux new-window -t "$session_name" -n "killer" -c "$exo_worktree_path"
    tmux send-keys -t "$session_name:killer" "__cmux-killer" Enter

    # Attach to the session, starting with the portal window
    tmux select-window -t "$session_name:portal"
    tmux attach-session -t "$session_name"
end
