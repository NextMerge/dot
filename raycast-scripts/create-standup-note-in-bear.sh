#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create standup note in Bear
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎤
# @raycast.argument1 { "type": "dropdown", "placeholder": "Week?", "data": [{"title": "First", "value": "First week"}, {"title": "Second", "value": "Second week"}, {"title": "Third", "value": "Third week"}, {"title": "Fourth", "value": "Fourth week"}, {"title": "Fifth", "value": "Fifth week"}, {"title": "Sixth", "value": "Sixth week"}, {"title": "Cooldown", "value": "Cooldown week"}]  }

# Documentation:
# @raycast.author MergeNext
# @raycast.authorURL https://raycast.com/MergeNext

OPTION=$1

# Function to calculate the next Monday
get_next_monday() {
  today=$(date +%Y-%m-%d)
  for i in {1..7}; do
    next_date=$(date -v +${i}d -j -f "%Y-%m-%d" "$today" +%Y-%m-%d)
    weekday=$(date -j -f "%Y-%m-%d" "$next_date" +%u)
    if [[ $weekday -eq 1 ]]; then
      echo "$next_date"
      break
    fi
  done
}

# Get the next Monday
NEXT_MONDAY=$(get_next_monday)

# Encode the title and text for the URL
ENCODED_TITLE=$(printf "Weekly Standup: %s" "$NEXT_MONDAY" | jq -sRr @uri)
ENCODED_TEXT=$(printf "#2-areas/work/standup
---
*$OPTION*
## Last week
- 
## This week
- " | jq -sRr @uri)

# Create a new note in Bear with the selected option and next Monday as the title
open "bear://x-callback-url/create?title=$ENCODED_TITLE&text=$ENCODED_TEXT"

echo "New note created in Bear with option: $OPTION and title: Note for $NEXT_MONDAY"
