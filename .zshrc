export PATH=~/bin/$(hostname):~/bin/$(uname -s):~/bin:$PATH
export EDITOR=vim
export LANG=en_US.UTF-8

setopt histignorealldups sharehistory prompt_subst

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

alias config='/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME'

if ls --version 2>&1 | grep -i gnu >/dev/null 
then
	alias ls='ls --color -Fh '
	alias ll='ls --color -Flh '
else
	alias ls='ls -GhF '
	alias ll='ls -GlhF '
fi

if [[ ! -a ~/bin/nao ]]; then
    echo '#!/bin/bash' > ~/bin/nao
    read "uservar?nao user: "
    read "passvar?nao pass: "
    echo 'DGLAUTH="'$uservar':'$passvar'" ssh -o SendEnv="DGLAUTH" nethack@alt.org' >> ~/bin/nao
    chmod +x ~/bin/nao
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh