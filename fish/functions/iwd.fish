function iwd --description "I want directory - Interactive directory navigation using fzf"
    set selected (__fd_without_protected --type d | fzf -i --preview 'eza -aF --color=always --icons --tree --level=1 {}')
    if test -n "$selected"
        cd "$selected"
    end
end 