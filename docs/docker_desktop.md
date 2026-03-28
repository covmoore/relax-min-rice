# Docker Desktop Setup on Hyprland (Arch Linux)

## Problem
Clicking the Docker Desktop waybar widget froze the entire screen for several minutes and never opened the application.

---

## What Was Tried

### 1. `--disable-gpu` flag
Added `--disable-gpu --no-sandbox` to the direct binary call in the waybar `on-click`. The VA-API error (`vaInitialize failed: unknown libva error`) suggested GPU acceleration was the culprit. This did not fix the freeze.

### 2. `setsid` + `LIBVA_DRIVER_NAME=dummy`
Wrapped the launch in `setsid` to detach from waybar's process group and used `LIBVA_DRIVER_NAME=dummy` to bypass the VA-API hang. The process started but no window appeared.

### 3. `gtk-launch docker-desktop`
Used the `.desktop` file launcher (`/usr/share/applications/docker-desktop.desktop`), which calls `/opt/docker-desktop/bin/docker-desktop` (the backend binary). This started the backend but not the GUI window.

### 4. `systemctl --user start docker-desktop`
The systemd service (`/usr/lib/systemd/user/docker-desktop.service`) runs `/opt/docker-desktop/bin/com.docker.backend`. Starting it showed backend activity in logs but the GUI window never appeared.

---

## Root Cause

The backend (`com.docker.backend`) was crashing immediately on startup due to a **file permission error**:

```
rename .tmp-settings-store.json settings-store.json: operation not permitted
```

The file `~/.docker/desktop/settings-store.json` had the **immutable flag** set via `chattr`, preventing the backend from writing its config on startup.

```bash
lsattr ~/.docker/desktop/settings-store.json
# Output: ----i---------e------- ...
```

---

## Fix

Remove the immutable flag:

```bash
sudo chattr -i ~/.docker/desktop/settings-store.json
```

After this, `systemctl --user start docker-desktop` starts the backend successfully, which in turn launches the Electron GUI (`/opt/docker-desktop/Docker Desktop`).

---

## Waybar Widget Setup

### Widget definition in `~/.config/waybar/config.jsonc`

```jsonc
"image#docker": {
    "path": "/home/covmoore/.config/waybar/docker.png",
    "size": 24,
    "tooltip": true,
    "tooltip-format": "Docker Desktop",
    "on-click": "bash /home/covmoore/.config/waybar/docker-launch.sh"
}
```

### Launch script `~/.config/waybar/docker-launch.sh`

Handles three states, and also kills the rogue tray process:

```bash
#!/bin/bash
# Kill the tray-only Docker Desktop process (launched with --reason=open-tray)
pkill -f "Docker Desktop.*--reason=open-tray" 2>/dev/null

# Focus Docker Desktop if open, otherwise launch it
if hyprctl clients | grep -q "class: Docker Desktop"; then
    # Window is open — focus it
    hyprctl dispatch focuswindow class:"Docker Desktop"
elif systemctl --user is-active --quiet docker-desktop; then
    # Backend running but window was closed — relaunch the GUI
    LIBVA_DRIVER_NAME=dummy setsid "/opt/docker-desktop/Docker Desktop" --no-sandbox &>/dev/null &
else
    # Nothing running — start backend (which launches the GUI)
    systemctl --user start docker-desktop
fi
```

| State | Action |
|---|---|
| Window is open | Focus the existing window |
| Backend running, window closed | Relaunch the Electron GUI directly |
| Nothing running | Start the systemd service (launches everything) |

### Duplicate Docker tray icon

Docker Desktop spawns a separate process (`Docker Desktop --reason=open-tray`) for its system tray icon, ignoring the `ShowSystemTray: false` setting in `settings-store.json`. The `pkill` at the top of the launch script kills it on each click.

The `tray` module in `config.jsonc` also has `ignored-items` set as a belt-and-suspenders filter:

```jsonc
"tray": {
    "spacing": 10,
    "ignored-items": ["chrome_status_icon_1", "Docker Desktop"]
}
```

---

## Key Files

| File | Purpose |
|---|---|
| `/usr/lib/systemd/user/docker-desktop.service` | Systemd user service — starts `com.docker.backend` |
| `/opt/docker-desktop/bin/com.docker.backend` | Backend binary |
| `/opt/docker-desktop/Docker Desktop` | Electron GUI binary |
| `/opt/docker-desktop/bin/docker-desktop` | Frontend launcher binary (used by `.desktop` file) |
| `~/.docker/desktop/settings-store.json` | Backend settings — must be writable |
| `~/.config/waybar/docker-launch.sh` | Waybar click handler script |
