#!/usr/bin/env bash
# Combined battery + power-profile widget for waybar.
#
#   (no args)  -> print JSON: charging bolt, battery %, battery-level icon,
#                 profile icon, colour class, and a tooltip with time left.
#   cycle      -> switch to the next power profile (wraps around) and exit;
#                 waybar re-runs the status form afterwards (exec-on-event).

set -euo pipefail

BAT=/sys/class/power_supply/BAT1
PROFILES=(power-saver balanced performance)   # cycle order

profile_now() { powerprofilesctl get 2>/dev/null || echo balanced; }

# ---- click action: advance to the next profile -------------------------------
if [[ "${1:-}" == "cycle" ]]; then
    cur="$(profile_now)"
    next="balanced"
    for i in "${!PROFILES[@]}"; do
        if [[ "${PROFILES[$i]}" == "$cur" ]]; then
            next="${PROFILES[(i + 1) % ${#PROFILES[@]}]}"
            break
        fi
    done
    powerprofilesctl set "$next"
    exit 0
fi

# ---- status form: emit JSON --------------------------------------------------
read_int() { local v; v="$(cat "$1" 2>/dev/null)" && [[ "$v" =~ ^[0-9]+$ ]] && echo "$v" || echo 0; }

cap="$(read_int "$BAT/capacity")"
status="$(cat "$BAT/status" 2>/dev/null || echo Unknown)"
profile="$(profile_now)"

# profile -> icon + CSS class (original power-profiles-daemon glyphs)
case "$profile" in
    power-saver) picon="";  pclass="power-saver" ;;
    balanced)    picon=""; pclass="balanced"    ;;
    performance) picon="";  pclass="performance" ;;
    *)           picon=""; pclass="balanced"    ;;
esac

# battery capacity -> level icon (empty -> full), original battery glyphs
if   (( cap >= 80 )); then bicon=""
elif (( cap >= 60 )); then bicon=""
elif (( cap >= 40 )); then bicon=""
elif (( cap >= 20 )); then bicon=""
else                       bicon=""
fi

# time remaining, computed from energy/power (µWh / µW)
energy_now="$(read_int "$BAT/energy_now")"
energy_full="$(read_int "$BAT/energy_full")"
power_now="$(read_int "$BAT/power_now")"

fmt_time() {  # minutes -> "Hh MMm" or "MMm"
    local m=$1
    if   (( m <= 0 ));  then printf 'unknown'
    elif (( m >= 60 )); then printf '%dh %02dm' $(( m / 60 )) $(( m % 60 ))
    else printf '%dm' "$m"; fi
}

time_line="time unknown"
if (( power_now > 0 )); then
    case "$status" in
        Charging)    time_line="$(fmt_time $(( (energy_full - energy_now) * 60 / power_now ))) until full" ;;
        Discharging) time_line="$(fmt_time $(( energy_now * 60 / power_now ))) remaining" ;;
    esac
fi
[[ "$status" == "Full" || "$status" == "Not charging" ]] && time_line="fully charged"


# CSS classes: profile, plus charging / critical state
classes="[\"$pclass\""
[[ "$status" == "Charging" || "$status" == "Full" ]] && classes+=",\"charging\""
(( cap <= 15 )) && [[ "$status" == "Discharging" ]] && classes+=",\"critical\""
classes+="]"

text="${picon}   ${cap}% ${bicon}"
tooltip="Battery ${cap}% — ${time_line}\\nProfile: ${profile} (click to cycle)"

printf '{"text":"%s","tooltip":"%s","class":%s,"percentage":%s}\n' \
    "$text" "$tooltip" "$classes" "$cap"
