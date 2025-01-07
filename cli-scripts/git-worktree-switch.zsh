#!/bin/zsh

all_worktrees=$(git worktree list | grep -v "(bare)" | awk '{print $1, substr($0, index($0,$3))}')

selected_worktree=$(
    echo "$all_worktrees" | sed 's|.*/\([^/]*\) |\1 |' | fzf --prompt="Select a worktree: " --header="Press CTRL-D to cancel" --margin=0,30%
)

if [[ -n "$selected_worktree" ]]; then
    just_selected_worktree=$(echo "$selected_worktree" | awk '{print $1}')
    cd "../$just_selected_worktree"
    echo "Switched to worktree: $just_selected_worktree"
    echo "Running ../on-worktree-switch.zsh..."
    zsh ../on-worktree-switch.zsh $just_selected_worktree
fi

