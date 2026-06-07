#!/bin/bash
SPECIAL="desktop"
ORIGIN_FILE="/tmp/hypr-show-desktop-origin"
CURRENT=$(hyprctl activeworkspace -j | jq '.id')

HIDDEN_COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.name == \"special:$SPECIAL\")] | length")

if [ "$HIDDEN_COUNT" -gt 0 ] && [ -f "$ORIGIN_FILE" ]; then
    ORIGIN=$(cat "$ORIGIN_FILE")
    rm "$ORIGIN_FILE"
    hyprctl dispatch workspace "$ORIGIN"
    hyprctl clients -j | jq -r "[.[] | select(.workspace.name == \"special:$SPECIAL\")] | .[].address" | while read addr; do
        hyprctl dispatch movetoworkspacesilent "$ORIGIN,address:$addr"
    done
else
    echo "$CURRENT" > "$ORIGIN_FILE"
    hyprctl clients -j | jq -r "[.[] | select(.workspace.id == $CURRENT)] | .[].address" | while read addr; do
        hyprctl dispatch movetoworkspacesilent "special:$SPECIAL,address:$addr"
    done
fi
