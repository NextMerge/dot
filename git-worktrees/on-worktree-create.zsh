#! /bin/zsh

# Alias the portal.env file in the portal worktree
PORTAL_WORKTREE=$1

if [ -z "$PORTAL_WORKTREE" ]; then
    echo "Error: No portal worktree provided"
    exit 1
fi

PORTAL_WORKTREE_DIR="${DOTS_CIVALGO_DIR}/portal/${PORTAL_WORKTREE}"

ln "${DOTS_CIVALGO_DIR}/portal/known.env" "${PORTAL_WORKTREE_DIR}/.env"

echo "Linked portal.env for ${PORTAL_WORKTREE}"
