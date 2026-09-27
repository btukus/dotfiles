#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Connect Microstation BT
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName Sidecar

blueutil --connect "Micro Station BT"
osascript -e 'display notification "Connected successfully" with title "Microstation BT"'
