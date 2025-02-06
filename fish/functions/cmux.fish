function cmux --description "Start Zellij session with civalgo configuration"
    # Check if Zellij session is already running
    if zellij ls | grep -q civalgo
        zellij attach civalgo
    else
        zellij --layout $DOTS_DIR/borpa-business/civalgo-layout.kdl
    end
end
