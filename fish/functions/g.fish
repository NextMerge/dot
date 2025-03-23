function g --description "Interactive git repository navigation with worktree support"
    set -l pre_selected_repos ~/dotfiles ~/.config/nvim

    # Find regular git repos
    set -l regular_repos (rg --hidden --files --glob '**/.git/HEAD' --glob '!**/Arhive git/**' --max-depth 6 "$GITTER_DIR" | sed 's|.git/HEAD||')

    # Find bare git repos
    set -l bare_repos (rg --hidden --files --glob '**/config' --glob '!**/.git/**' --max-depth 6 "$GITTER_DIR")

    # Read every entry in bare_repos and check if it contains "bare = true"
    # If it does, replace the entry with the directory name
    # If it doesn't, remove the entry
    set -l bare_repos (for repo in $bare_repos
        if rg -q "bare = true" "$repo" 2>/dev/null
            echo (dirname "$repo")
        end
    end)

    # Combine all repos
    set -l all_repos $regular_repos $bare_repos $pre_selected_repos

    set -l selected_dir (
        string join \n $all_repos | fzf --prompt="Select a directory: " --header="Press CTRL-D to go to gitter folder"
    )

    if test -z "$selected_dir"
        cd $GITTER_DIR
        return
    end

    cd "$selected_dir"

    # Check if worktrees folder exists
    if test -d worktrees
        set -l all_worktrees (git worktree list | grep -v "(bare)" | awk '{print $1, substr($0, index($0,$3))}' | sed 's|.*/\([^/]*\) |\1 |')
        set -l selected_worktree (string join \n $all_worktrees | fzf --prompt="Select a worktree: " --header="Press CTRL-D to cancel" --margin=0,30%)

        if test -n "$selected_worktree"
            cd (echo "$selected_worktree" | awk '{print $1}')
        end
    end
end

