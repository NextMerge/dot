function g --description "Interactive git repository navigation with worktree support"
    set -l pre_selected_repos '~/dotfiles' '~/.config/nvim'

    # Find regular git repos
    set -l regular_repos (rg --hidden --files --glob '**/.git/HEAD' --glob '!**/Arhive git/**' --max-depth 6 "$GITTER_DIR" | sed 's|.git/HEAD||' | string replace $GITTER_DIR/ '')

    # Find bare git repos
    set -l bare_repos (rg --hidden --files --glob '**/config' --glob '!**/.git/**' --max-depth 6 "$GITTER_DIR")

    # Read every entry in bare_repos and check if it contains "bare = true"
    # If it does, replace the entry with the directory name
    # If it doesn't, remove the entry
    set -l bare_repos (for repo in $bare_repos
        if rg -q "bare = true" "$repo" 2>/dev/null
            echo (dirname "$repo" | string replace $GITTER_DIR/ '')
        end
    end)

    # Combine all repos
    set -l all_repos $regular_repos $bare_repos $pre_selected_repos

    set -l selected_repo (
        string join \n $all_repos | fzf --no-clear --prompt="Select a directory: " --header="Press CTRL-D to go to gitter folder"
    )

    set -l selected_repo_path
    if contains "$selected_repo" $pre_selected_repos
        set selected_repo_path (string replace '~' $HOME "$selected_repo")
    else
        set selected_repo_path "$GITTER_DIR/$selected_repo"
    end

    if test -z "$selected_repo"
        tput rmcup
        cd $GITTER_DIR
        return
    end

    if test -d "$selected_repo_path/worktrees"
        set -l worktree_path (git_worktree_select "$selected_repo_path")
        if test $status -eq 0
            cd "$worktree_path"
        else
            cd "$selected_repo_path"
        end
    else
        tput rmcup
        cd "$selected_repo_path"
    end
end

