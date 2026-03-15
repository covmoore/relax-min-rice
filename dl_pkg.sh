echo "downloading packages..."

packages=("neovim" "obsidian" "spotify-launcher" "waybar" "hyprpaper" "git" "openssh" "brightnessctl" "hyprlock" "mpd" "pavucontrol" "docker" "docker-compose")

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

wget https://download.docker.com/linux/static/stable/x86_64/docker-29.2.1.tgz -qO- | tar xvfz - docker/docker --strip-components=1
sudo cp -rp ./docker /usr/local/bin/ && rm -r ./docker
