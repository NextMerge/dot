if not status is-interactive
    return
end

set -g fish_greeting ""

set -gx DOTS_DIR "$HOME/dotfiles"
set -gx GITTER_DIR "$HOME/Documents/gitter"

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd

abbr -a n 'nvim'
abbr -a pn 'pnpm'
abbr -a l 'eza -aF --icons --width=80'

set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_NO_UPDATE_REPORT_NEW 1

# Generic color var for some programs (such as eza)
set -gx LS_COLORS "$(vivid generate catppuccin-mocha)"

### bat
set -gx BAT_THEME "Catppuccin Mocha"
# Use bat coloring for man pages
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

### fzf
set -gx FZF_DEFAULT_OPTS " \
    --info=inline \
    --border \
    --layout=reverse \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"

# Keybindings
fzf --fish | source

eval (starship init fish)

# NOTE: Says zoxide completions need to be at the end of the file
eval "$(zoxide init fish)"
