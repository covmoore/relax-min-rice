# relax-min-rice

A minimal Hyprland rice for daily use on Arch Linux.

## Components

| Component | Software |
|---|---|
| Window Manager | Hyprland |
| Terminal | Kitty |
| Status Bar | Waybar |
| App Launcher | Wofi / Hyprlauncher |
| Wallpaper | Hyprpaper |
| Lock Screen | Hyprlock |
| File Manager | Dolphin |
| Browser | Brave |
| Editor | Neovim |
| Notes | Obsidian |
| Music | Spotify |
| Notifications | Dunst |

---

## Installation

### 1. Clone the config

```bash
git clone https://github.com/covmoore/.config.git ~/.config
```

### 2. Install yay (AUR helper)

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si
```

### 3. Run the package installer

```bash
chmod +x ~/.config/dl_pkg.sh
bash ~/.config/dl_pkg.sh
```

This installs all pacman packages (hyprland, kitty, waybar, wofi, dolphin, neovim, pipewire, etc.) and AUR packages (brave-bin, spotify, docker-desktop, nerd-fonts).

### 4. Enable services

```bash
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable sddm
```

### 5. Start Hyprland

Log out and select **Hyprland** from the SDDM session menu, or launch directly:

```bash
Hyprland
```

---

## Changing Themes

Themes live in `~/.config/themes/<theme-name>/theme.conf`. The update script patches Hyprland, Waybar, Kitty, Hyprpaper, and Hyprlock all at once, then reloads everything.

### Apply a theme

```bash
bash ~/.config/themes/update-theme.sh chill-vibes
```

### Create a new theme

1. Create a directory: `~/.config/themes/<your-theme>/`
2. Add a `theme.conf` using the template below
3. Add a wallpaper image at the path specified by `$wallpaper`
4. Run the update script with your theme name

**theme.conf template:**

```bash
$text_color         = #0a0908
$widget_color       = #5e503f
$foreground_color   = #c6ac8f
$active_widget      = #432818
$background_color   = #22333b
$cursor_color       = #333d29
$terminal_background = #22333b
$terminal_foreground = #c6ac8f
$wallpaper          = $HOME/.config/themes/<your-theme>/images/wallpaper.jpg

$greeting_color           = #c6ac8f
$input_border_color       = #c6ac8f
$failed_input_border_color = #9b1515
$time_color               = #5e503f
$date_color               = #104a65
$greeting_message         = YOUR MESSAGE HERE
```

---

## Autostart Workspaces

On launch, applications are automatically placed into workspaces:

| Workspace | App |
|---|---|
| 1 | Kitty (terminal) |
| 2 | Neovim |
| 3 | Brave (browser) |
| 4 | Obsidian (notes) |
| special:spotify | Spotify |

---

## Keybindings

`$mainMod` = **Super** (Windows key)

### Applications

| Keybind | Action |
|---|---|
| `Super + Q` | Open terminal (Kitty) |
| `Super + N` | Open Neovim in terminal |
| `Super + B` | Open browser (Brave) |
| `Super + E` | Open file manager (Dolphin) |
| `Super + R` | Open app launcher (Wofi) |
| `Super + Space` | Open Hyprlauncher |

### Window Management

| Keybind | Action |
|---|---|
| `Super + C` | Close active window |
| `Super + F` | Toggle fullscreen |
| `Super + J` | Toggle split (dwindle) |
| `Super + H` | Show desktop |
| `Super + M` | Exit Hyprland |
| `Super + L` | Lock screen (Hyprlock) |
| `Super + T` | Toggle trackpad |
| `Super + LMB drag` | Move window |
| `Super + RMB drag` | Resize window |

### Focus

| Keybind | Action |
|---|---|
| `Super + ←` | Move focus left |
| `Super + →` | Move focus right |
| `Super + ↑` | Move focus up |
| `Super + ↓` | Move focus down |

### Workspaces

| Keybind | Action |
|---|---|
| `Super + 1–0` | Switch to workspace 1–10 |
| `Super + Shift + 1–0` | Move active window to workspace 1–10 |
| `Super + Scroll up` | Next workspace |
| `Super + Scroll down` | Previous workspace |

### Scratchpads

| Keybind | Action |
|---|---|
| `Super + S` | Toggle Spotify scratchpad |
| `Super + D` | Toggle Discord scratchpad |
| `Super + Shift + S` | Move window to magic scratchpad |

### Media & Hardware Keys

| Keybind | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp` | Brightness +5% |
| `XF86MonBrightnessDown` | Brightness -5% |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86AudioPlay / Pause` | Play / Pause |
