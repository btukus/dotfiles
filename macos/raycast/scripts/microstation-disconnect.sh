#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Disconnect Microstation BT
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName Sidecar

blueutil --disconnect "Micro Station BT"
osascript -e 'display notification "Disconnected successfully" with title "Microstation BT"'
