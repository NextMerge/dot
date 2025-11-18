#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Bear Open Today
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐻

# Documentation:
# @raycast.author NextMerge
# @raycast.authorURL https://raycast.com/NextMerge

open "bear://x-callback-url/open-note?title=$(date +%Y-%m-%d)"