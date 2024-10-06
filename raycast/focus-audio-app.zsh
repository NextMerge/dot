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
if pgrep -x "Podcasts"; then
    open -a "Podcasts"
else
    open -a "Music"
fi

# Exit with success status
exit 0
