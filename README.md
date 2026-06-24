# Nix-gabrln

NixOS config with **MangoWM** and **Noctalia**.

## Installation

> **No Git?** Use `nix-shell -p git` to get a temporary git without installing it system-wide.

```bash
# 1. Clone
git clone -b experimental https://github.com/gabrln/Nix-gabrln.git /home/.config/nixos

# 2. Copy hardware config from the installer
cp /etc/nixos/hardware-configuration.nix /home/.config/nixos/host/hardware-configuration.nix

# 3. Build
cd /home/.config/nixos
nixos-rebuild switch --flake .#gabrln
```

> The repo is cloned to `/home/.config/nixos` (outside the user's home) — make sure the path exists and has correct permissions.

## Structure

```
.
├── flake.nix
├── vars.nix
├── host/
│   ├── default.nix
│   ├── packages.nix
│   ├── services.nix
│   └── hardware-configuration.nix
└── modules/
    ├── core/
    │   ├── base.nix
    │   ├── audio.nix
    │   ├── latency.nix
    │   ├── gpu.nix
    │   └── docker.nix
    └── home/
        ├── home.nix
        ├── wayland/
        │   ├── mango.nix
        │   └── noctalia.nix
        ├── programs/
        │   ├── kitty.nix
        │   ├── zsh.nix
        │   ├── yazi.nix
        │   ├── zellij.nix
        │   ├── nvim.nix
        │   └── git.nix
        ├── webapps.nix
        └── dotfiles/
```

- **flake.nix** — inputs, outputs, system modules
- **vars.nix** — user, hostname, locale
- **host/** — machine config (boot, packages, services, hardware)
- **modules/core/** — system-level: base, audio (PipeWire), latency (ZRAM), gpu (Intel), docker
- **modules/home/** — home-manager: identity, wayland (MangoWM + Noctalia), programs (kitty, zsh, yazi, zellij, nvim, git), webapps, dotfiles

## Stack

| Layer | Tool |
|--------|-----------|
| Compositor | MangoWM |
| Shell | Noctalia V5 |
| Terminal | Kitty |
| File Manager | Yazi |
| Multiplexer | Zellij |
| Prompt | Starship |
