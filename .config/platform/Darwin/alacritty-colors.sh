# clones alacritty colors if not already there

if [ ! -d ~/.config/alacritty-colors ]
then
  git clone https://github.com/eendroroy/alacritty-theme.git ~/.config/alacritty-colors
fi

COLOR_DIR="~/.config/alacritty-colors/themes"
LIGHT_COLOR='solarized_light.yaml'
DARK_COLOR='solarized_dark.yaml'

alias day="alacritty-colorscheme -C $COLOR_DIR -a $LIGHT_COLOR -V"
alias night="alacritty-colorscheme -C $COLOR_DIR -a $DARK_COLOR -V"
