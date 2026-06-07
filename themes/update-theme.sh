#!/bin/bash
# update-theme.sh
THEME="$1"
if [ -z "$THEME" ]; then
    echo "Usage: $0 <theme-name>"
    exit 1
fi
THEME_CONFIG="$HOME/.config/themes/$THEME/theme.conf"
WAYBAR_CSS="$HOME/.config/waybar/style.css"
HYPRLAND="$HOME/.config/hypr/hyprland.conf"
KITTY="$HOME/.config/kitty/kitty.conf"
HYPRPAPER="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK="$HOME/.config/hypr/hyprlock.conf"


# REPLACING WAYBAR VARS
sed -i "s/@define-color widget-color .*/@define-color widget-color $(grep \$widget_color $THEME_CONFIG | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color text-color .*/@define-color text-color $(grep \$text_color $THEME_CONFIG | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color bg-color .*/@define-color bg-color $(grep \$background_color $THEME_CONFIG | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color fg-color .*/@define-color fg-color $(grep \$foreground_color $THEME_CONFIG | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color active-widget .*/@define-color active-widget $(grep \$active_widget $THEME_CONFIG | cut -d'=' -f2);/" $WAYBAR_CSS


# REPLACING HYPRLAND VARS
sed -i "s/\$PRIMARY_COLOR =.*/\$PRIMARY_COLOR = rgb($(grep \$active_widget $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLAND

sed -i "s/\$SECONDARY_COLOR =.*/\$SECONDARY_COLOR = rgb($(grep \$foreground_color $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLAND

sed -i "s/\$ACCENT_COLOR =.*/\$ACCENT_COLOR = rgb($(grep \$active_widget $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLAND


# REPLACING KITTY VARS
sed -i "s/^cursor .*/cursor $(grep \$cursor_color $THEME_CONFIG | cut -d'=' -f2)/" $KITTY

sed -i "s/^foreground .*/foreground $(grep \$terminal_foreground $THEME_CONFIG | cut -d'=' -f2 | xargs)/" $KITTY

sed -i "s/^background .*/background $(grep \$terminal_background $THEME_CONFIG | cut -d'=' -f2 | xargs)/" $KITTY


# REPLACE HYPRPAPER VARS
WALLPAPER=$(grep '\$wallpaper' $THEME_CONFIG | cut -d'=' -f2 | xargs | sed "s|\$HOME|$HOME|g")
sed -i "s|preload = .*|preload = $WALLPAPER|" $HYPRPAPER
sed -i "s|path = .*|path = $WALLPAPER|" $HYPRPAPER


# REPLACE HYPRLOCK VARS
sed -i "s/\$GREETING_COLOR=.*/\$GREETING_COLOR= rgb($(grep \$greeting_color $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLOCK

sed -i "s/\$INPUT_BORDER_COLOR=.*/\$INPUT_BORDER_COLOR= rgb($(grep \$input_border_color= $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLOCK

sed -i "s/\$FAILED_INPUT_BORDER_COLOR=.*/\$FAILED_INPUT_BORDER_COLOR= rgb($(grep \$failed_input_border_color $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLOCK

sed -i "s/\$DATE_COLOR=.*/\$DATE_COLOR= rgb($(grep \$date_color $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLOCK

sed -i "s/\$TIME_COLOR=.*/\$TIME_COLOR= rgb($(grep \$time_color $THEME_CONFIG | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLOCK

sed -i "s/\$GREETING_MESSAGE=.*/\$GREETING_MESSAGE= $(grep \$greeting_message $THEME_CONFIG | cut -d'=' -f2 | xargs)/" $HYPRLOCK


# Reload Hyprland and Waybar
hyprctl reload
kill -SIGUSR1 $(pgrep kitty)
pkill waybar; nohup waybar &>/dev/null &
pkill hyprpaper; hyprpaper &
pkill hyprlock; hyprlock &
