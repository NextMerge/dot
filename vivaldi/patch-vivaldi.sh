#!/bin/bash

# Taken from https://forum.vivaldi.net/topic/10592/patching-vivaldi-with-batch-scripts

# Quit Vivaldi
osascript -e 'quit app "Vivaldi.app"'

# Find path to Framework folder of current version and save it as variable
findPath="$(find /Applications/Vivaldi.app -name Vivaldi\ Framework.framework)/Resources/vivaldi"

# Copy custom js file to Vivaldi.app
cp $DOTS_DIR/vivaldi/custom.js "$findPath"

# Save path to window.html as variable
browserHtml="$findPath"/window.html

# Insert references, if not present, and save to temporary file
sed 's|  </body>|    <script src="custom.js"></script></body>|' "$browserHtml" >"$browserHtml".temp

# Backup original file
cp "$browserHtml" "$browserHtml".bak

# Overwrite
mv "$browserHtml".temp "$browserHtml"

# Pause script
read -rsp $'Press [Enter] to restart Vivaldi...\n'

# Open Vivaldi
open /Applications/Vivaldi.app
