#! /bin/zsh

DEFAULT_BRANCH=$(printf "main\nmaster" | fzf --prompt="Select default branch: ")
if [ -z "$DEFAULT_BRANCH" ]; then
    echo "No default branch selected, exiting..."
    exit 1
fi

REMOTE_REPO=$1

git clone $REMOTE_REPO --bare .

git branch | xargs git branch -D

git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

git fetch

git worktree add stable -b main --track origin/$DEFAULT_BRANCH

git worktree add feature origin/$DEFAULT_BRANCH
git worktree add unstable origin/$DEFAULT_BRANCH
