# Nix-gabrln

Configuração NixOS com **MangoWM** e **Noctalia V5**.

## Branches

| Branch | Uso |
|--------|-----|
| `experimental` | Desenvolvimento ativo, kernel NixOS padrão |
| `main` | Espelho do `experimental` (estável/produção) |

## Instalação

> **Sem Git?** Use `nix-shell -p git` para um git temporário.

```bash
# 1. Clonar (HTTPS — sem chave SSH)
git clone https://github.com/gabrln/Nix-gabrln.git ~/.config/nixos

# 2. Copiar hardware-config do instalador
cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/host/hardware-configuration.nix

# 3. Build
cd ~/.config/nixos
sudo nixos-rebuild switch --flake .#gabrln
```

### Chave SSH (opcional, para push)

```bash
# Gerar chave SSH (se não existir)
ssh-keygen -t ed25519 -C "seu-email@github.com"

# Adicionar ao ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copiar chave pública
cat ~/.ssh/id_ed25519.pub

# Adicionar no GitHub > Settings > SSH and GPG keys > New SSH key

# Testar conexão
ssh -T git@github.com

# Trocar remote para SSH
cd ~/.config/nixos
git remote set-url origin git@github.com:gabrln/Nix-gabrln.git
```

## Stack

| Camada | Ferramenta |
|--------|------------|
| Kernel | NixOS padrão (`linuxPackages`) |
| Compositor | MangoWM |
| Shell | Noctalia V5 |
| Áudio | PipeWire (config explícita de baixa latência) |
| Gaming | GameMode, MangoHud, Steam + Gamescope |
| Terminal | Kitty |
| Editor | Neovim (nvf) |
| Gerenciador de Arquivos | Yazi + Nautilus |
| Multiplexador | Zellij |
| Prompt | Starship (tematizado pelo Noctalia) |
