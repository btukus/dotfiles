tell application "System Settings"
	activate
	-- Open the Bluetooth pane (the pane id may vary with macOS version)
	reveal pane id "com.apple.Bluetooth"
	delay 2 -- Adjust delay as needed for System Settings to load
end tell

tell application "System Events"
	tell first window of application process "System Settings"
		-- NOTE: The following UI element path is an example.
		-- You may need to use a UI inspector tool (like UI Browser)
		-- to determine the exact hierarchy on your system.
		try
			-- Assume the list of Bluetooth devices is contained in a scroll area.
			tell scroll area 1 of group 1 of splitter group 1 of group 1
				set deviceFound to false
				-- Look for a row in the table that contains "Micro Station BT"
				repeat with aRow in (rows of table 1)
					try
						if (value of static text 1 of aRow) contains "Micro Station BT" then
							set deviceFound to true
							click aRow
							exit repeat
						end if
					end try
				end repeat
				
				if deviceFound then
					delay 1
					-- Now click the "Connect" button that should appear in the device's detail pane.
					try
						click button "Connect" of group 2 of window 1
					on error
						display dialog "Connect button not found. The UI structure may have changed."
					end try
				else
					display dialog "Device 'Micro Station BT' not found."
				end if
			end tell
		on error errMsg
			display dialog "Error accessing Bluetooth UI elements: " & errMsg
		end try
	end tell
end tell
