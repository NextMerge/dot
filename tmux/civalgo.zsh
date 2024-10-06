#!/bin/zsh

PORTAL_COLOR='\033[0;34m'
NC='\033[0m' # No Color
SOMBRA_COLOR='\033[0;35m'

WORKING_DIR='/Users/markjarjour/Documents/gitter/borpa-business/civalgo'
SOMBRA_DIR="${WORKING_DIR}/sombra"
PORTAL_DIR="${WORKING_DIR}/portal"

# Check if the script was called with a "silent" argument
SILENT_MODE=false
if [[ "$1" == "silent" ]]; then
    SILENT_MODE=true
fi


# Check if a session named "civalgo" already exists
if tmux has-session -t civalgo 2>/dev/null; then
    if [ "$SILENT_MODE" = false ]; then
        # If it exists, attach to it
        tmux attach-session -t civalgo
    fi
else
    # If it doesn't exist, create a new session
    # Start a new tmux session named "civalgo"
    tmux new-session -d -s civalgo

    # Create the first window with 4 panes
    tmux rename-window -t civalgo:0 'dev-docker'
    tmux split-window -v
    tmux split-window -h
    tmux select-pane -t civalgo:dev-docker.0
    tmux split-window -h -t civalgo:dev-docker.0


    # Set working directories for each pane
    tmux send-keys -t civalgo:dev-docker.0 "cd $PORTAL_DIR" Enter
    tmux send-keys -t civalgo:dev-docker.2 "cd $SOMBRA_DIR" Enter
    tmux send-keys -t civalgo:dev-docker.3 "cd $SOMBRA_DIR" Enter

    tmux send-keys -t civalgo:dev-docker.0 'npm run dev' Enter
    tmux send-keys -t civalgo:dev-docker.2 'open -jga Docker && sleep 10 && npm run docker-start' Enter
    tmux send-keys -t civalgo:dev-docker.3 'npm run dev' Enter

    
    print_success() {
        echo -e "\033[0;32m$1\033[0m"
    }

    print_success "Docker and dev panes started..."

    tmux send-keys -t civalgo:dev-docker.1 "cd $PORTAL_DIR; tmux wait-for -S portal-cd-complete" Enter
    tmux wait-for portal-cd-complete

    print_success "Portal pane cd'd..."

    # If we're on master branch, do a pull then npm i, otherwise echo a message
    tmux send-keys -t civalgo:dev-docker.1 'git branch; tmux wait-for -S portal-git-branch-complete' Enter
    tmux wait-for portal-git-branch-complete

    if tmux capture-pane -p -t civalgo:dev-docker.1 | grep -q "\* master"; then
        echo -e "${PORTAL_COLOR}On master branch. Pulling changes and installing dependencies...${NC}"
        tmux send-keys -t civalgo:dev-docker.1 'git pull && npm i && tmux wait-for -S portal-pull-complete' Enter
        tmux wait-for portal-pull-complete
        echo -e "${PORTAL_COLOR}Pull and install completed on master branch.${NC}"
    else
        echo -e "${PORTAL_COLOR}Not on master branch. Skipping pull and install.${NC}"
    fi

    tmux send-keys -t civalgo:dev-docker.1 "cd $SOMBRA_DIR; tmux wait-for -S sombra-cd-complete" Enter
    tmux wait-for sombra-cd-complete

    print_success "Sombra pane cd'd..."


    # Define the target message
    SUCCESS_MESSAGE="Connection to 127.0.0.1 port 5432 [tcp/postgresql] succeeded!"

    echo -e "${SOMBRA_COLOR}Waiting for PostgreSQL to be available...${NC}"

    # Loop until the target message is found in the output of the command
    while true; do
        # Run the command and capture the output in the third window
        tmux send-keys -t civalgo:dev-docker.1 'nc -zv 127.0.0.1 5432; tmux wait-for -S sombra-nc-complete' Enter
        tmux wait-for sombra-nc-complete
        OUTPUT=$(tmux capture-pane -J -S -100 -p -t civalgo:dev-docker.1)

        # Check if the output contains the success message
        if [[ "$OUTPUT" == *"$SUCCESS_MESSAGE"* ]]; then
            echo -e "${SOMBRA_COLOR}PostgreSQL is available.${NC}"
            break
        else
            sleep 10  # Add a 10-second delay before retrying
        fi
    done

    # Check that we're on master branch
    tmux send-keys -t civalgo:dev-docker.1 'git branch; tmux wait-for -S sombra-git-branch-complete' Enter
    tmux wait-for sombra-git-branch-complete

    if tmux capture-pane -p -t civalgo:dev-docker.1 | grep -q "\* master"; then
        echo -e "${SOMBRA_COLOR}On master branch. Pulling changes and installing dependencies...${NC}"

        # regex pattern to match: Batch 25 run: 1 migrations
        SUCCESS_MESSAGE="Batch [0-9]+ run: [0-9]+ migrations"

        ERROR_MESSAGE="migration failed"

        # Run git pull, npm install, and database migration
        echo -e "${SOMBRA_COLOR}Running git pull and npm install...${NC}"
        tmux send-keys -t civalgo:dev-docker.1 'git pull && npm i; tmux wait-for -S sombra-npm-complete' Enter
        tmux wait-for sombra-npm-complete

        echo -e "${SOMBRA_COLOR}Git pull and npm install complete.${NC}"

        echo -e "${SOMBRA_COLOR}Running Knex migration...${NC}"
        tmux send-keys -t civalgo:dev-docker.1 'npm run db:migrate; tmux wait-for -S sombra-knex-complete' Enter
        tmux wait-for sombra-knex-complete

        # Capture the tmux pane output
        TMUX_CAPTURE=$(tmux capture-pane -J -S -100 -p -t civalgo:dev-docker.1)
        
        # Extract the Knex migration output
        SOMBRA_PANE_OUTPUT=$(echo "$TMUX_CAPTURE" | sed -n '/knex migrate:latest/,$p' | tail -n +2)
        
        if echo "$SOMBRA_PANE_OUTPUT" | grep -qE ".*$ERROR_MESSAGE.*"; then
            echo -e "${SOMBRA_COLOR}Knex migration had an error! Moving on...${NC}"
        elif echo "$SOMBRA_PANE_OUTPUT" | grep -qE ".*$SUCCESS_MESSAGE.*"; then
            echo -e "${SOMBRA_COLOR}Knex migration detected. Killing Dockerprocess in pane 0.2...${NC}"

            # Send Ctrl+C to interrupt the process running in pane 0.2, then start it again
            tmux send-keys -t civalgo:dev-docker.2 C-c
            sleep 2  # Give some time for the process to stop
            tmux send-keys -t civalgo:dev-docker.2 'npm run docker-start' Enter
            echo -e "${SOMBRA_COLOR}Docker process interrupted. Restarting...${NC}"
        else 
            echo -e "${SOMBRA_COLOR}No Knex migration detected. Continuing...${NC}"
        fi
    else
        echo -e "${SOMBRA_COLOR}Not on master branch. Skipping pull, install, and migration.${NC}"
    fi

    print_success "Setting up Docker.app monitoring..."

    # Function to check if Docker.app is running
    tmux send-keys -t civalgo:dev-docker.1 $'
    check_docker() {
        if ! pgrep -q "Docker"; then
            echo "Docker.app is not running. Killing civalgo tmux session..."
            osascript -e '\''display notification "Docker.app is not running. Killing civalgo tmux session." with title "Docker Alert"'\''
            sleep 10
            if ! pgrep -q "Docker"; then
                tmux kill-session -t civalgo
                exit 1
            fi
        fi
    }

    while true; do
        sleep 30
        check_docker
    done
    ' Enter

    print_success "All done! Attaching to the session in 5 seconds..."
    sleep 5

    # Select the first window and first pane
    tmux select-window -t civalgo:0
    tmux select-pane -t 0

    if [ "$SILENT_MODE" = false ]; then
        # Attach to the session
        tmux attach-session -t civalgo
    fi
fi
