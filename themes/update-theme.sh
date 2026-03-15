#!/bin/bash
# update-theme.sh
THEME="$1"
COLORS_FILE="$HOME/.config/themes/chill-vibes/colors.conf"
WAYBAR_CSS="$HOME/.config/waybar/style.css"
HYPRLAND="$HOME/.config/hypr/hyprland.conf"
KITTY="$HOME/.config/kitty/kitty.conf"


# REPLACING WAYBAR VARS
sed -i "s/@define-color widget-color .*/@define-color widget-color $(grep \$color1 $COLORS_FILE | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color text-color .*/@define-color text-color $(grep \$color0 $COLORS_FILE | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color bg-color .*/@define-color bg-color $(grep \$color4 $COLORS_FILE | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color fg-color .*/@define-color fg-color $(grep \$color2 $COLORS_FILE | cut -d'=' -f2);/" $WAYBAR_CSS

sed -i "s/@define-color active-widget .*/@define-color active-widget $(grep \$color3 $COLORS_FILE | cut -d'=' -f2);/" $WAYBAR_CSS


# REPLACING HYPRLAND VARS
sed -i "s/\$PRIMARY_COLOR =.*/\$PRIMARY_COLOR = rgb($(grep \$color3 $COLORS_FILE | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLAND

sed -i "s/\$SECONDARY_COLOR =.*/\$SECONDARY_COLOR = rgb($(grep \$color2 $COLORS_FILE | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLAND

sed -i "s/\$ACCENT_COLOR =.*/\$ACCENT_COLOR = rgb($(grep \$color3 $COLORS_FILE | cut -d'=' -f2 | cut -d '#' -f2))/" $HYPRLAND


# REPLACING KITTY VARS
sed -i "s/cursor #.*/cursor $(grep \$color5 $COLORS_FILE | cut -d'=' -f2)/" $KITTY

sed -i "s/foreground #.*/foreground$(grep \$color7 $COLORS_FILE | cut -d'=' -f2)/" $KITTY

sed -i "s/background #.*/background$(grep \$color6 $COLORS_FILE | cut -d'=' -f2)/" $KITTY
# Reload Hyprland and Waybar
hyprctl reload
pkill -SIGUSR1 waybar
kill -SIGUSR1 $(pgrep kitty)
nohup waybar
