#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Turn Off FlashSpace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻 

# Documentation:
# @raycast.author NextMerge
# @raycast.authorURL https://raycast.com/NextMerge

# Quit FlashSpace app
osascript -e 'quit app "FlashSpace"'

defaults write com.apple.WindowManager GloballyEnabled -bool true

# Unhide all windows
osascript -e 'tell application "System Events" to set visible of every process to true'

echo "FlashSpace quit and Stage Manager on"
