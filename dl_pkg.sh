echo "downloading packages..."

pacman_packages=(
	"base"
	"base-devel"
	"blueman"
	"bluez"
	"bluez-utils"
	"brightnessctl"
	"devtools"
	"dkms"
	"docker"
	"docker-compose"
	"dolphin"
	"dunst"
	"efibootmgr"
	"electron"
	"fd"
	"git"
	"github-cli"
	"grim"
	"grub"
	"gst-plugin-pipewire"
	"htop"
	"hyprland"
	"hyprlock"
	"hyprpaper"
	"intel-ucode"
	"iwd"
	"kitty"
	"libpulse"
	"libva-nvidia-driver"
	"linux"
	"linux-firmware"
	"linux-headers"
	"linux-lts"
	"linux-lts-headers"
	"mpd"
	"nano"
	"neovim"
	"network-manager-applet"
	"networkmanager"
	"nvidia-open-dkms"
	"obsidian"
	"openssh"
	"pavucontrol"
	"pipewire"
	"pipewire-alsa"
	"pipewire-jack"
	"pipewire-pulse"
	"polkit-kde-agent"
	"qt5-wayland"
	"qt6-wayland"
	"sddm"
	"slurp"
	"smartmontools"
	"sof-firmware"
	"steam"
	"unzip"
	"uwsm"
	"vim"
	"waybar"
	"wget"
	"wireless_tools"
	"wireplumber"
	"wofi"
	"wpa_supplicant"
	"xclip"
	"xdg-desktop-portal-hyprland"
	"xdg-utils"
	"xorg-server"
	"xorg-xinit"
	"zig"
	"zram-generator"
)

for package in "${pacman_packages[@]}"; do
	if pacman -Qi "${package}" > /dev/null 2>&1; then
		echo "${package} is already installed"
	else
		sudo pacman -S --noconfirm "${package}"
	fi
done

aur_packages=(
	"brave-bin"
	"docker-desktop"
	"spotify"
	"woff2-font-awesome"
	"yay"
	"yay-debug"
)

for package in "${aur_packages[@]}"; do
	if pacman -Qi "${package}" > /dev/null 2>&1; then
		echo "${package} is already installed"
	else
		yay -S --noconfirm "${package}"
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
