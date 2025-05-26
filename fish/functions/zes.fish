function zes
    if test -n "$ZELLIJ"
        keyboardmaestro DC8E22A4-BCE2-46F8-AB53-B9FD73729967
        return 0
    end

    set -l dirs (fd -t d -d 1 . $GITTER_DIR --exclude "Arhive git")
    set -l selected_project (printf '%s\n' $dirs | sd "$GITTER_DIR/" "" | sd "/\$" "" | fzf)
    echo (zellij list-sessions -n)
    echo (zellij list-sessions -n | rg -q "^$selected_project\$")

    if zellij list-sessions -n | rg -q "^$selected_project\s"
        zellij attach $selected_project
        return 0
    end

    if functions -q __zes_$selected_project
        __zes_$selected_project
        return 0
    end

    set -l working_dir $GITTER_DIR/$selected_project
    if test -d worktrees
        set working_dir (git_worktree_select)
    end

    set -l temp_layout (mktemp -t zes_layout_XXXXXX.kdl)
    cat ~/.config/zellij/layouts/zes_template.kdl \
        | sd "THE_SESSION_NAME" "$selected_project" \
        | sd "THE_CURRENT_WORKING_DIRECTORY" "$working_dir" \
        > $temp_layout
    zellij --layout $temp_layout
end

