# rstad dotfiles

Managed with [chezmoi](https://chezmoi.io). New machine:

    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply rstad

`init` asks one question, the git email, and everything else follows from it:

| email        | context  | ssh agent / password manager |
|--------------|----------|------------------------------|
| `@gmail.com` or `@users.noreply.github.com` | personal | Bitwarden |
| anything else| work     | 1Password                    |

- Commits are always signed with whatever key the ssh agent offers: the
  password manager's agent locally, or the forwarded agent over ssh.
- `~/.ssh/authorized_keys` accepts the keys of both GitHub accounts
  (`rstad`, `chimerstad`), fetched at apply time.

A personal email is stored and used as `3325739+rstad@users.noreply.github.com`.
Change the email with `chezmoi init --prompt`.

This repo is public, so anything machine- or work-specific goes in files
that are sourced but never committed: `~/.zshrc.local`, `~/.gitconfig.local`.

Day to day: `chezmoi update` pulls and applies; `chezmoi diff` previews.
