function zes
    if test -n "$ZELLIJ"
        keyboardmaestro DC8E22A4-BCE2-46F8-AB53-B9FD73729967
        return 0
    end

    set -l dirs (fd -t d -d 1 . $GITTER_DIR --exclude "Arhive git")
    set -l selected_dir (printf '%s\n' $dirs | sed "s|$GITTER_DIR/||" | sed 's|/$||' | fzf)
    
    cd $GITTER_DIR/$selected_dir
    if test -n "$selected_dir"
        if not zellij list-sessions | grep -q "^$selected_dir\$"
            if functions -q zes_$selected_dir
                zes_$selected_dir
            else
                zellij attach -c $selected_dir
            end
        else
            zellij attach $selected_dir
        end
    end
end

