export DOTS_DIR="$HOME/dotfiles"
export GITTER_DIR="$HOME/Documents/gitter"

_fd_common() {
    local fd_args=("$@")
    {
        fd ${fd_args[@]} . "$HOME" -H \
            --exclude "Library" \
            --exclude "node_modules" \
            --exclude "Pictures" \
            --exclude "Music" \
            --exclude "Movies" \
            --exclude "iCloud Drive"
        fd ${fd_args[@]} . "$HOME/Library/Application Support" -H \
            --exclude "node_modules"
    }
}

iwd() { # I want directory
    local selected="$(
        _fd_common --type d |
            fzf -i --preview 'eza -aF --color=always --icons --tree --level=1 {}'
    )"

    if [ -n "$selected" ]; then
        cd "$selected"
    fi
}

iwf() { # I want file
    local selected="$(
        _fd_common --type f --type l |
            fzf -i --preview 'bat --style=numbers --color=always {}'
    )"

    if [ -n "$selected" ]; then
        bat "$selected"
    fi
}

gws() { # git worktree switch
    source "$DOTS_DIR/cli-scripts/git-worktree-switch.zsh"
}

gwc() { # git worktree clone
    source "$DOTS_DIR/cli-scripts/git-worktree-clone.zsh" "$1"
}

gl() { # git list
    source "$DOTS_DIR/cli-scripts/gitter.zsh"
}

cmux() {
    zsh $DOTS_DIR/borpa-business/civalgo-tmux-sess.zsh
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias pn=pnpm
alias lg=lazygit
alias n=nvim
alias ll='eza -aF --icons'

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_UPDATE_REPORT_NEW=1

# Generic color var for some programs (such as eza)
export LS_COLORS="$(vivid generate catppuccin-mocha)"

### bat
export BAT_THEME="Catppuccin Mocha"
# Use bat coloring for man pages
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

### fzf
# Set up fzf key bindings and fuzzy completion
# NOTE: fzf must be sourced through zsh-vi-mode to make sure fzf's key bindings work
zvm_after_init_commands+=('source <(fzf --zsh)')

export FZF_DEFAULT_OPTS=" \
    --info=inline
    --border
    --layout=reverse
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"

export PATH=$PATH:$(go env GOPATH)/bin

# Specify which node version to use in fnm
eval "$(fnm env --use-on-cd --shell zsh)"

eval "$(starship init zsh)"

### zsh-vi-mode
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

precmd() {
    # Set SIGINT to ctrl-e while editing a command
    stty intr \^E
}
preexec() {
    # Now set it to ctrl-c when a command is running
    stty intr \^C
}
ZVM_VI_INSERT_ESCAPE_BINDKEY=^C

function zvm_vi_yank() {
    zvm_yank
    echo ${CUTBUFFER} | pbcopy
    zvm_exit_visual_mode
}

### All content below is autogenerated

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
    _npm_completion() {
        local words cword
        if type _get_comp_words_by_ref &>/dev/null; then
            _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
        else
            cword="$COMP_CWORD"
            words=("${COMP_WORDS[@]}")
        fi

        local si="$IFS"
        if ! IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
            COMP_LINE="$COMP_LINE" \
            COMP_POINT="$COMP_POINT" \
            npm completion -- "${words[@]}" \
            2>/dev/null)); then
            local ret=$?
            IFS="$si"
            return $ret
        fi
        IFS="$si"
        if type __ltrim_colon_completions &>/dev/null; then
            __ltrim_colon_completions "${words[cword]}"
        fi
    }
    complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
    _npm_completion() {
        local si=$IFS
        compadd -- $(COMP_CWORD=$((CURRENT - 1)) \
            COMP_LINE=$BUFFER \
            COMP_POINT=0 \
            npm completion -- "${words[@]}" \
            2>/dev/null)
        IFS=$si
    }
    compdef _npm_completion npm
elif type compctl &>/dev/null; then
    _npm_completion() {
        local cword line point words si
        read -Ac words
        read -cn cword
        let cword-=1
        read -l line
        read -ln point
        si="$IFS"
        if ! IFS=$'\n' reply=($(COMP_CWORD="$cword" \
            COMP_LINE="$line" \
            COMP_POINT="$point" \
            npm completion -- "${words[@]}" \
            2>/dev/null)); then

            local ret=$?
            IFS="$si"
            return $ret
        fi
        IFS="$si"
    }
    compctl -K _npm_completion npm
fi
###-end-npm-completion-###

# NOTE: Says zoxide completions need to be at the end of the file
eval "$(zoxide init zsh)"
