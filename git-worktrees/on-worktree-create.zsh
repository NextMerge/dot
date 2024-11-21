#! /bin/zsh

# Get worktree dir with pwd
WORKTREE_DIR=$(pwd)
GIT_DIR=$(dirname "$WORKTREE_DIR")

if [ -f "${GIT_DIR}/known.env" ]; then
    ln "${GIT_DIR}/known.env" "${WORKTREE_DIR}/.env"
    echo "Linked known.env for ${WORKTREE}"
else
    echo "No known.env found in ${GIT_DIR}, skipping..."
fi
