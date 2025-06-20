#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Turn On FlashSpace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️

# Documentation:
# @raycast.author NextMerge
# @raycast.authorURL https://raycast.com/NextMerge

defaults write com.apple.WindowManager GloballyEnabled -bool false

# Launch FlashSpace app
open -jga "FlashSpace"

echo "Stage Manager off and FlashSpace launched"
