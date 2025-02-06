# Based on script taken from https://forum.vivaldi.net/topic/10592/patching-vivaldi-with-batch-scripts

function vimod
    osascript -e 'quit app "Vivaldi.app"'

    set path_to_vivaldi_entry_point (fd 'Vivaldi Framework.framework' /Applications/Vivaldi.app --type d)
    set path_to_vivaldi_entry_point "$path_to_vivaldi_entry_point"Resources/vivaldi

    if not test -d "$path_to_vivaldi_entry_point"
        echo "Vivaldi Framework.framework not found"
        return 1
    end

    cp $DOTS_DIR/vivaldi/custom.js "$path_to_vivaldi_entry_point"

    set html_entry_point "$path_to_vivaldi_entry_point/window.html"

    if not rg -q "custom.js" "$html_entry_point"
        string replace -r '</body>' '<script src="custom.js"></script></body>' -- (cat "$html_entry_point") >"$html_entry_point"
        set_color green
        echo "Patched $html_entry_point"
        set_color normal
    else
        set_color blue
        echo "Already patched $html_entry_point"
        set_color normal
    end

    read -P "Press [Enter] to restart Vivaldi or Ctrl-C to exit..."

    if test "$status" -eq 1
        return 0
    end

    open /Applications/Vivaldi.app
end

