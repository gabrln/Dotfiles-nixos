# Nix-gabrln

NixOS config: MangoWM + Noctalia + nvf.

## Repo map

```
~/.config/nixos/
├── flake.nix          -- inputs: nixpkgs, hm, mango, noctalia, chaotic, nix-gaming, nvf
├── vars.nix           -- user/host/locale/timezone
├── host/              -- boot, services, packages, hardware-config
├── modules/
│   ├── core/          -- base, latency, audio, gpu, cpu, ananicy, podman
│   └── home/          -- home.nix + programs/ + wayland/ + dotfiles/
```

## Vault

`~/Documents/obsidian/B05 Systems/` — docs do sistema.
`~/Documents/obsidian/C04 Agent/` — instruções do agente.
