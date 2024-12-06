export DOTS_DIR="$HOME/dotfiles"
export GITTER_DIR="$HOME/Documents/gitter"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias pn=pnpm
alias lg=lazygit
alias nv=nvim

export FZF_DEFAULT_OPTS="--info=inline --border --layout=reverse"
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_UPDATE_REPORT_NEW=1

export PATH=$PATH:$(go env GOPATH)/bin

# Git worktree switch command
gws() {
    source "$DOTS_DIR/git-worktrees/git-worktree-switch.zsh"
}

gwc() {
    source "$DOTS_DIR/git-worktrees/git-worktree-clone.zsh" "$1"
}

gs() {
    source "$DOTS_DIR/cli-scripts/gitter.zsh"
}

# Specify which node version to use
eval "$(fnm env --use-on-cd --shell zsh)"

eval "$(starship init zsh)"

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

### All content below is autogenerated

# Created by `pipx` on 2024-07-16 02:25:51
export PATH="$PATH:/Users/markjarjour/.local/bin"

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

# Says zoxide completions need to be at the end of the file
eval "$(zoxide init zsh)"
