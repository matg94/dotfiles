CONFIG_DIR=$HOME/.config

# Wayland Setup
mkdir -p $CONFIG_DIR/mako
mkdir -p $CONFIG_DIR/sway
mkdir -p $CONFIG_DIR/waybar
mkdir -p $CONFIG_DIR/wofi

cp -r ./mako $CONFIG_DIR/mako
cp -r ./sway $CONFIG_DIR/sway
cp -r ./waybar $CONFIG_DIR/waybar
cp -r ./wofi $CONFIG_DIR/wofi

# Neovim Setup
mkdir -p $CONFIG_DIR/nvim

cp -r ./nvim $CONFIG_DIR/nvim

# Utilities Setup
mkdir -p $CONFIG_DIR/utilities
mkdir -p $CONFIG_DIR/wallpapers

cp -r ./utilities $CONFIG_DIR/utilities
cp -r ./wallpapers $CONFIG_DIR/wallpapers
