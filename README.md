# rstad dotfiles

Managed with [chezmoi](https://chezmoi.io). New machine (what to set up
before and after, per machine type, is under [New machine](#new-machine)):

    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply rstad

`init` asks one question, the git email, and everything else follows from it:

| email        | context  | ssh agent / password manager |
|--------------|----------|------------------------------|
| `@gmail.com` or `@users.noreply.github.com` | personal | Bitwarden |
| anything else| work     | 1Password                    |

- Commits are always signed with a key from the ssh agent: the password
  manager's agent locally, or the forwarded agent over ssh. The key has to
  belong to the GitHub account that matches the commit email, otherwise the
  commit is refused. `SIGN_WITH_ANY_KEY=1 git commit ...` overrides that.
- `~/.ssh/authorized_keys` accepts the keys of both GitHub accounts
  (`rstad`, `chimerstad`), fetched at apply time.
- Tools (ripgrep, fd, fzf, bat, zoxide, eza, delta, dust, glow, gh, tldr, atuin,
  piknik, starship, zellij) are installed when missing: from apt or brew (`.chezmoidata.toml`),
  or as release binaries in `~/.local/bin`, refreshed weekly
  (`.chezmoiexternal.toml.tmpl`). Upgrading what apt and brew installed is
  left to them.
- The terminal font (Sarasa Term SC, `font` in `.chezmoidata.toml`) goes on
  the machines with a screen: `~/Library/Fonts` on Macs, and from WSL into the
  Windows user's fonts (no admin needed). It follows the latest release; a new
  one is picked up within a week. Restart the terminal afterwards.

A personal email is stored and used as `3325739+rstad@users.noreply.github.com`.
Change the email with `chezmoi init --prompt`.

This repo is public, so anything machine- or work-specific goes in files
that are sourced but never committed: `~/.zshrc.local`, `~/.gitconfig.local`.

Day to day: `chezmoi update` pulls and applies; `chezmoi diff` previews.

## New machine

Every machine type uses the install command at the top. What differs is what
has to be in place first and what to do afterwards.

| Machine | Email to give | SSH agent |
|---|---|---|
| Personal Linux (headless) | personal | forwarded from the laptop |
| Personal Mac | personal | Bitwarden |
| Work Mac | work | 1Password |
| Work WSL | work | 1Password, through a pipe bridge |
| Personal WSL | personal | not supported yet |

### Everywhere

- `curl` and `git` must be present.
- On Linux, the install script uses sudo to run apt when a package is
  missing. Run the first apply from an interactive shell so sudo can ask for
  a password. Macs don't need sudo.
- Signing needs an agent with the right key. The key must belong to the
  GitHub account that matches the commit email (see the agent column above).
- Afterwards:
  - `gh auth login`. git uses gh as its credential helper.
  - `atuin login` with the sync key from the password manager, then
    `atuin sync` to pull history from the other hosts now instead of at the
    next automatic sync. To bring in this host's old zsh history, scrub it
    first, then `atuin import zsh`. If Claude Code runs there:
    `atuin hook install claude-code`.
  - Copy `~/.piknik.toml` from another host with scp. It holds shared
    secrets, so it never goes in this repo.
  - Check: `ssh -T git@github.com` greets the right account, and
    `git commit --allow-empty -m test` in a scratch repo signs the commit.

### Personal Linux (headless)

Before:
- Install `zsh`, then `chsh -s "$(command -v zsh)"`. chezmoi does not change
  the login shell.
- Debian 13 or Ubuntu 24.04. fd and bat come as `fdfind` and `batcat`, and
  chezmoi links them as `fd` and `bat` in `~/.local/bin`.
- Tailscale with "Use Tailscale DNS" on, so short host names resolve.
- SSH in from a laptop with agent forwarding. `~/.ssh/config` here already
  forwards it to my own hosts.

After:
- Log out and back in to get zsh.
- No font is installed on headless hosts, because the terminal you sit at
  draws the text.
- Anything host-specific (extra PATH lines, env for one tool) goes in
  `~/.zshrc.local`.

### Personal Mac

Before:
- Homebrew (installs tmux, tree, eza). On Intel Macs, never brew
  Rust tools: Homebrew has no Intel bottles and builds Rust and LLVM from
  source. The release binaries cover them.
- Bitwarden desktop, signed in, with Settings → SSH agent turned on.
- A terminal: WezTerm or the zellij terminal. Both are configured here.
- Tailscale with "Use Tailscale DNS" on.

After:
- Restart the terminal to pick up the font (Sarasa Term SC).
- `pkshot` hotkey (see below).
- rbw (`brew install rbw pinentry-mac`) if you want Bitwarden from the shell.
  Not managed here yet.
- If brew or cargo already had zellij, starship and the like, chezmoi lists
  the duplicate copies after apply. Remove them yourself.

### Work Mac

Before:
- Homebrew, and WezTerm or the zellij terminal.
- 1Password desktop, signed in, with Settings → Developer → "Use the SSH
  agent" on.
- `~/.config/1Password/ssh/agent.toml` listing the work key first.
  Otherwise the agent offers the personal key first, GitHub logs you in as
  the personal account, and work repos fail.
- Tailscale is optional. A work laptop isn't on the personal tailnet, so
  `~/.ssh/config` jumps through west to reach tailnet-only hosts.

After:
- `gh auth login` and SSO-authorize it for the work org.
- Clone the work dotfiles repo to `~/.config/dotfiles-work`. Its name
  stays out of this public repo; it's in my notes and in that repo's own
  README. Then `chezmoi apply`. It
  provides the signing key setup, GITHUB_TOKEN, `workenv` and work-only shell
  settings. Each later apply pulls it.
- `~/.zshrc.local` and `~/.gitconfig.local`: only what is specific to this
  one laptop.
- atuin: also `atuin hook install codex` if you use it.
- Restart the terminal for the font. Set up the `pkshot` hotkey.

### Work WSL

Before, on Windows:
- 1Password with the SSH agent turned on, and `agent.toml` listing the work
  key first (`%LOCALAPPDATA%\1Password\config\ssh\`).
- `winget install albertony.npiperelay`, then restart the terminal.
- WezTerm. Its config is copied to the Windows home on each apply.

Before, in WSL (Ubuntu 24.04):
- `zsh`, then `chsh -s "$(command -v zsh)"`.
- Passwordless sudo for apt.

After:
- `.zshrc` bridges the 1Password pipe to `~/.1password/agent.sock` with
  socat (installed by chezmoi). If either piece is missing, it says so at
  shell start.
- Clone the work dotfiles repo to `~/.config/dotfiles-work`, as on the Mac.
- Put LAN-only host entries in `~/.ssh/config.local`. The Windows-side
  `%USERPROFILE%\.ssh\config` is written from this repo on each apply; a
  hand-written one is moved to `config.local` there.
- Links open in the Windows browser through wslview (installed by chezmoi).
- Restart Windows Terminal or WezTerm for the font.

### Personal WSL

Placeholder: no personal WSL machine is set up yet. The agent bridge in
`.zshrc` only handles 1Password, so Bitwarden on Windows will need its own.

`pkshot` (Mac only) takes a screenshot straight to piknik, so another host can
`pkp > /tmp/shot.png`. Give it a hotkey once per Mac: in Shortcuts, make a
shortcut with one Run Shell Script action, `~/.local/bin/pkshot`, then add a
keyboard shortcut in its details (e.g. Ctrl+Option+Cmd+4). The first run needs
Shortcuts → Settings → Advanced → Allow Running Scripts, and Screen Recording
permission for Shortcuts.

`linktest` prints sample links (parens, markdown, Chinese text, OSC 8, a
wrapped URL) to check how a terminal or multiplexer detects and opens them.
Each opens example.com with `?case=N`, so the address bar shows what was taken.
