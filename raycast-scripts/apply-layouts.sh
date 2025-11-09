#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Become Personal
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🪟

# Documentation:
# @raycast.author NextMerge
# @raycast.authorURL https://raycast.com/NextMerge

# Apply Browse layout
open "raycast://customWindowManagementCommand?&name=Layout%20-%20Browse"

# Small delay to ensure first command processes
sleep 0.5

# Apply Media layout
open "raycast://customWindowManagementCommand?&name=Layout%20-%20Media"

# Small delay to ensure second command processes
sleep 0.5

# Apply Writing layout
open "raycast://customWindowManagementCommand?&name=Layout%20-%20Writing"

echo "Layouts applied"

