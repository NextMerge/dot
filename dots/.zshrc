export DOTS_DIR="$HOME/dotfiles"
export GITTER_DIR="$HOME/Documents/gitter"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias pn=pnpm
alias n=nvim
alias l='eza -aF --icons'

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_UPDATE_REPORT_NEW=1

### fzf
source <(fzf --zsh)

export FZF_DEFAULT_OPTS=" \
    --info=inline
    --border
    --layout=reverse
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"

# Specify which node version to use in fnm
eval "$(fnm env --use-on-cd --shell zsh)"

