function gws --description "Git Worktree Switch - Interactive worktree switching"
    set -l all_worktrees (git worktree list | grep -v "(bare)" | awk '{print $1, substr($0, index($0,$3))}'| tr '\n' '\n')
    set -l selected_worktree (string join \n $all_worktrees | sed 's|.*/\([^/]*\) |\1 |' | fzf --prompt="Select a worktree: " --header="Press CTRL-D to cancel" --margin=0,30%)

    if test -n "$selected_worktree"
        set -l just_selected_worktree (echo "$selected_worktree" | awk '{print $1}')
        cd "../$just_selected_worktree"
        echo "Switched to worktree: $just_selected_worktree"
        echo "Running ../on-worktree-switch.zsh..."
        zsh ../on-worktree-switch.zsh $just_selected_worktree
    end
end 