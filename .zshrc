export PATH=~/bin/$(hostname):~/bin/$(uname -s):~/bin:$PATH
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

setopt histignorealldups sharehistory prompt_subst


# source platform-specific files
# platform name: Darwin, SunOS, Linux, etc
platform=$(uname -s)
if [ -d ~/.config/platform/$(uname -s) ]; then
  for file in $(find ~/.config/platform/$platform -name "*.sh"); do
    #echo platform $file
    . $file
  done
fi

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

alias config='/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME'
alias ebv='source env/bin/activate'

if ls --version 2>&1 | grep -i gnu >/dev/null 
then
	alias ls='ls --color -F '
	alias ll='ls --color -Flh '
else
	alias ls='ls -GF '
	alias ll='ls -GlhF '
fi

mkdir -p ~/bin

if [[ ! -a ~/bin/nao ]]; then
    echo '#!/bin/bash' > ~/bin/nao
    read "uservar?nao user: "
    read "passvar?nao pass: "
    echo 'DGLAUTH="'$uservar':'$passvar'" ssh -o SendEnv="DGLAUTH" nethack@alt.org' >> ~/bin/nao
    chmod +x ~/bin/nao
fi

# this is probably reckless?  but basically trying to ensure p10k is installed
if [ ! -d ~/powerlevel10k ]
then
 git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
  if [ ! -f ~/.p10k-daily-$(date +%Y%m%d) ]; then
    rm -f ~/.p10k-daily-*
    rm -rf ~/powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    touch ~/.p10k-daily-$(date +%Y%m%d)
  fi
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
