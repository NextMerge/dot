#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open/Focus Audio App
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Open Apple Music, unless Apple Podcast is opened then focus that.
# @raycast.author MergeNext
# @raycast.authorURL https://raycast.com/MergeNext

# Check if Podcasts is open
if pgrep -fl /System/Applications/Podcasts.app/Contents/MacOS/Podcasts; then
    open -a "Podcasts"
else
    osascript -e 'tell application "Music" to activate'
fi

# Exit with success status
exit 0
