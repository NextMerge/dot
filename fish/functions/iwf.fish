function iwf --description "I want file - Interactive file selection and preview using fzf"
    set selected (__fd_without_protected --type f --type l | fzf -i --preview 'bat --style=numbers --color=always {}')
    if test -n "$selected"
        bat "$selected"
    end
end 