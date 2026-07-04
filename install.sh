#!/usr/bin/env bash
# relax-min-rice installer
# 1. Installs packages via dl_pkg.sh
# 2. Copies every file tracked in this repo into ~/.config, overwriting the
#    current configs (kitty, hypr, waybar, themes, ...). Any file in ~/.config
#    that is NOT tracked in this repo is left untouched.
#
# Usage:
#   ./install.sh                 # install packages, then deploy configs
#   ./install.sh --no-packages   # only deploy configs, skip dl_pkg.sh
#   ./install.sh --no-backup     # do not back up overwritten files

set -euo pipefail

SKIP_PACKAGES=0
BACKUP=1
for arg in "$@"; do
	case "$arg" in
		--no-packages) SKIP_PACKAGES=1 ;;
		--no-backup)   BACKUP=0 ;;
		-h|--help)
			grep '^#' "$0" | sed 's/^# \{0,1\}//'
			exit 0 ;;
		*)
			echo "unknown option: $arg" >&2
			exit 1 ;;
	esac
done

# Repo root = directory this script lives in.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "relax-min-rice installer"
echo "  repo:   $SCRIPT_DIR"
echo "  target: $CONFIG_DIR"

# 1. Packages ----------------------------------------------------------------
if [ "$SKIP_PACKAGES" -eq 0 ]; then
	echo "==> installing packages (dl_pkg.sh)"
	bash "$SCRIPT_DIR/dl_pkg.sh"
else
	echo "==> skipping package install (--no-packages)"
fi

# 2. Deploy configs ----------------------------------------------------------
# If the repo is already the config dir, the files are in place already.
if [ "$SCRIPT_DIR" = "$CONFIG_DIR" ]; then
	echo "==> repo is already at $CONFIG_DIR, nothing to copy"
	exit 0
fi

cd "$SCRIPT_DIR"
BACKUP_DIR="$CONFIG_DIR/.relax-min-rice-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> deploying tracked files into $CONFIG_DIR"
count=0
while IFS= read -r file; do
	dest="$CONFIG_DIR/$file"
	mkdir -p "$(dirname "$dest")"
	if [ "$BACKUP" -eq 1 ] && [ -e "$dest" ]; then
		mkdir -p "$(dirname "$BACKUP_DIR/$file")"
		cp -a "$dest" "$BACKUP_DIR/$file"
	fi
	cp -a "$file" "$dest"
	echo "  $file"
	count=$((count + 1))
done < <(git ls-files)

echo "==> done: deployed $count file(s)"
if [ "$BACKUP" -eq 1 ] && [ -d "$BACKUP_DIR" ]; then
	echo "    overwritten files backed up to: $BACKUP_DIR"
fi
