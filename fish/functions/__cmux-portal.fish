function __cmux-portal
    if not test -d worktrees
        return
    end

    set -l all_worktrees (git worktree list | grep -v "(bare)" | awk '{print $1, substr($0, index($0,$3))}' | sed 's|.*/\([^/]*\) |\1 |')
    set -l selected_worktree (string join \n $all_worktrees | fzf --prompt="Select a worktree: " --header="Press CTRL-D to cancel")

    if test -z "$selected_worktree"
        return
    end

    cd (printf "$selected_worktree" | awk '{print $1}')

    # Check if we're on master branch
    if git branch --show-current | grep -q master
        git pull
        npm i
    else
        set_color cyan
        echo "Not on master branch. Skipping pull and install."
        sleep 4
    end

    npm run dev
end
