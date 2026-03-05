echo "downloading packages..."

packages=("neovim" "obsidian" "spotify-launcher" "waybar" "hyprpaper" "git" "openssh" "brightnessctl" "hyprlock" "mpd" "pavucontrol")

for package in "${packages[@]}"; do
	if pacman -Qi "${package}" > /dev/null; then
		echo "${package} is already installed"
	else
		sudo pacman -S --noconfirm ${package};
	fi
done

NERD_DIRECTORY="~/.config/nerd-fonts-git"
if [ -d "$NERD_DIRECTORY" ]; then
	echo "nerd fonts already downloaded"
else
	echo "Installing nerd fonts"
	yay -S nerd-fonts-git
	cd "$NERD_DIRECTORY"
	makepkg -si --noconfirm
	echo "Installed nerd-fonts"
fi
