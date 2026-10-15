#!/bin/sh
# zsh completions for tools whose installs don't put one where zsh looks: the
# release binaries, and Debian's fd and bat (packaged as fdfind and batcat).
# Regenerated after every apply (about 0.1s) so they match what's installed.
# dust can't print its own; .chezmoiexternal fetches it into the same place.
dir=$HOME/.local/share/zsh/site-functions
mkdir -p "$dir"

# gen <name> <command...>: save the command's output as _<name>, if it has one
gen() {
    name=$1
    shift
    command -v "$1" > /dev/null 2>&1 || return 0
    if "$@" > "$dir/.new" 2> /dev/null && [ -s "$dir/.new" ]; then
        mv "$dir/.new" "$dir/_$name"
    fi
    rm -f "$dir/.new"
}

gen gh gh completion -s zsh
gen rg rg --generate complete-zsh
gen fd fd --gen-completions zsh
gen bat bat --completion zsh
gen delta delta --generate-completion zsh
gen glow glow completion zsh
gen zellij zellij setup --generate-completion zsh
gen starship starship completions zsh

# Debian's bat writes its completion for "batcat"; claim both names
if [ -f "$dir/_bat" ]; then
    sed '1s/^#compdef .*/#compdef bat batcat/' "$dir/_bat" > "$dir/.new" && mv "$dir/.new" "$dir/_bat"
fi
