# rstad dotfiles
Having finally spent more than fifteen minutes making adhoc changes to a config file I finally decided to start keeping this stuff in one place.

Mostly this came about from trying to get `tmux` to work right across a few different scenarios.  Some quick searching led me to [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles) via [Ask HN: What do you use to manage dotfiles?](https://news.ycombinator.com/item?id=11070797) and it seemed like a neat way to get started.

## Stuff I use
I've been using [alacritty](https://github.com/jwilm/alacritty) with [tmux](https://github.com/tmux/tmux) on my work Mac for a while, but at home I'm usually using [ssh from an old Chromebook](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en "Chromebook Secure Shell App").  This gave rise to a lot of tmux-in-tmux as well as some challenges with dealing with copy/paste behavior being inconsistent. 

I'm not a terribly sophisticated user of cool text editing stuff, which is probably reflected by the very brief `.vimrc`.  
## Dependencies
In order for the things I do use to work, I believe these things need to be done/setup first:
* `git`
* `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
* `tmux` version need to be at least 1.9 (for [tpm](https://github.com/tmux-plugins/tpm)), probably higher for my config but I don't actually know for sure.  I'm using 2.8 and 2.9a mostly at the moment.
* `gawk` is recommended for some `tmux` plugins, maybe even required?
* [OSC 52 helper script](https://chromium.googlesource.com/apps/libapps/+/master/hterm/etc/osc52.sh) needs to be available if on a remote host
* font for `alacritty`: [Sarasa-Gothic](https://github.com/be5invis/Sarasa-Gothic/releases) - based on [Iosevka](https://github.com/be5invis/Iosevka) but has better Simplified Chinese

## Install
I don't have any idea how you might make these useful for yourself, but, when I want this stuff on a new host, I basically just follow the directions from [https://www.atlassian.com/git/tutorials/dotfiles] in the section *Install your dotfiles onto a new system (or migrate to this setup)*

## Todo
* try out 
  * [tmux-xpanes]( https://github.com/greymd/tmux-xpanes)
  * [tmux-fingers](https://github.com/Morantron/tmux-fingers) because I love [vimium](https://vimium.github.io/)
  * [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
  * [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
  * [tmux-slack-counter](https://github.com/x4121/tmux-slack-counter)
* fix up
  * the alacritty config really only ever needs to be on my mac, so why am I putting it anywhere else?
* cleanup / include
  * weechat
  * .[ba/z/fi]shrc if ever I actually put anything in them, and get everything to use the same shell.


## Resources
I have cobbled this together from a few places, but probably these few most of all:
* tmux
  * [https://gist.github.com/spicycode/1229612]
  * [https://github.com/hashbang/dotfiles/blob/master/tmux/.tmux.conf]
  * [https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf] in particular the bits described in
    * [Tmux in practice: local and nested remote tmux sessions](https://www.freecodecamp.org/news/tmux-in-practice-local-and-nested-remote-tmux-sessions-4f7ba5db8795/)
    * [tmux in practice: integration with system clipboard](https://www.freecodecamp.org/news/tmux-in-practice-integration-with-system-clipboard-bcd72c62ff7b/)
  * [Copying to clipboard from tmux and Vim using OSC 52](https://sunaku.github.io/tmux-yank-osc52.html) although ultimately I followed in the footsteps of [this comment](https://sunaku.github.io/tmux-yank-osc52.html#comment-4563469106)
* dotfiles
  * [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles)
* alacritty
  * [this comment](https://github.com/jwilm/alacritty/issues/62#issuecomment-347552058) as a workaround for the associated issue
