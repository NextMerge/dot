# Define the bonus array
bonus=(~/dotfiles ~/.config/nvim)

# Combine the git repository search with the bonus directories
cd $(
  (
    rg --hidden --files --glob '**/.git/HEAD' --glob '!**/Arhive git/**' . | sed 's|.git/HEAD||'
    printf "%s\n" "${bonus[@]}"
  ) | fzf
)

nvim
