#!bin/bash

cp com.robinsloan.note_server.plist ~/Library/LaunchAgents/
echo "✔ Moved file describing service to your LaunchAgents folder"
launchctl load -w ~/Library/LaunchAgents/com.robinsloan.note_server.plist
echo "✔ Loaded service"
echo "(It should be available after your next restart.)"