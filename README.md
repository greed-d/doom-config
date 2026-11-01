# Doom Emacs config

My private Doom Emacs configuration (`$DOOMDIR`). This repo contains **only** the
config (`init.el`, `config.el`, `packages.el`), not Doom Emacs itself or its
installed packages.

## Restore on a fresh machine

Requires Emacs 29+ and Git. This config was last verified with Emacs 31.1 and
Doom core commit `59cdaa3` (2026-10-02). A much newer/older Doom may need small
config adjustments.

```bash
# 1. Install Doom Emacs core
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs

# 2. Set up Doom without generating a default config
~/.config/emacs/bin/doom install --no-config

# 3. Restore this config
git clone https://github.com/greed-d/doom-config.git ~/.config/doom

# 4. Install the modules/packages declared in init.el and packages.el
~/.config/emacs/bin/doom sync
```

Then start Emacs. If anything misbehaves, run `~/.config/emacs/bin/doom doctor`.

> If `~/.config/doom` already exists (e.g. Doom was installed without
> `--no-config`), move it aside before step 3, or clone elsewhere and copy the
> files in.

## Update the backup

```bash
cd ~/.config/doom
git add -A
git commit -m "Describe the change"
git push
```

After changing `init.el` or `packages.el`, run `doom sync` locally as usual.

## Notes

- Keep secrets (tokens, API keys) out of `config.el` — this repo is public.
- Doom core is updated separately with `doom upgrade`; it is not tracked here.
