pre_selected_repos=(~/dotfiles ~/.config/nvim)

selected_dir=$(
  (
    # Find regular git repos
    rg --hidden --files --glob '**/.git/HEAD' --glob '!**/Arhive git/**' --max-depth 6 "$GITTER_DIR" | sed 's|.git/HEAD||'
    # Find bare git repos
    rg --hidden --files --glob '**/config' --glob '!**/.git/**' --max-depth 6 "$GITTER_DIR" | while read -r file; do
      if rg -q "bare = true" "$file" 2>/dev/null; then
        dirname "$file"
      fi
    done
    # Add bonus directories
    printf "%s\n" "${pre_selected_repos[@]}"
  ) | fzf --prompt="Select a directory: " --header="Press CTRL-D to go to gitter folder"
)

cd "$selected_dir"

# Check if worktrees folder exists
if [[ -d "worktrees" ]]; then
  all_worktrees=$(git worktree list | grep -v "(bare)" | awk '{print $1, substr($0, index($0,$3))}')
  # List all level 1 folders in worktrees directory
  selected_worktree=$(
    echo "$all_worktrees" | sed 's|.*/\([^/]*\) |\1 |' | fzf --prompt="Select a worktree: " --header="Press CTRL-D to cancel" --margin=0,30%
  )

  if [[ -n "$selected_worktree" ]]; then
    cd "$(echo "$selected_worktree" | awk '{print $1}')"
  fi
fi
