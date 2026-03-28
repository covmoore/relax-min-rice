#!/bin/bash
# Kill the tray-only Docker Desktop process (launched with --reason=open-tray)
pkill -f "Docker Desktop.*--reason=open-tray" 2>/dev/null

# Focus Docker Desktop if open, otherwise launch it
if hyprctl clients | grep -q "class: Docker Desktop"; then
    hyprctl dispatch focuswindow class:"Docker Desktop"
elif systemctl --user is-active --quiet docker-desktop; then
    # Backend running but window closed — relaunch the GUI
    LIBVA_DRIVER_NAME=dummy setsid "/opt/docker-desktop/Docker Desktop" --no-sandbox &>/dev/null &
else
    systemctl --user start docker-desktop
fi
