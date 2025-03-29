function iwf --description "I want file - Interactive file selection and preview using fzf"
    set selected (__fd_without_protected --type f --type l | fzf -i \
        --preview 'bat --style=numbers --color=always {}' \
        --header "C-y: Copy path, C-d: Go to dir, C-v: View file" \
        --expect=ctrl-y,ctrl-d,ctrl-v)
    
    if test -n "$selected"
        set key (echo $selected | cut -d' ' -f1)
        set file (echo $selected | cut -d' ' -f2-)
        
        switch $key
            case ctrl-y
                echo $file | pbcopy
                echo "Path copied: $file"
            case ctrl-d
                cd (dirname $file)
            case ctrl-v
                bat $file
            case '*'
                cd (dirname $file)
                bat $file
        end
    end
end

