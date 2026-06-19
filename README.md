# NixOS Config (MangoWM + Noctalia)

Esta é a configuração declarativa do NixOS para o usuário `gsouza`, integrando o compositor **MangoWM** e a interface gráfica **Noctalia Shell**.

## Estrutura do Repositório

```text
nixos-config/
├── flake.nix                  # Definição dos canais de entrada e módulos (Mango, Noctalia, Greeter, Snappy Switcher)
├── configuration.nix          # Configurações globais do sistema NixOS (usuários, locale, greetd, console)
├── hardware-configuration.nix # Mapeamento físico dos discos (copiado do seu sistema local)
├── home.nix                   # Configuração de usuário via Home Manager (Zsh, Kitty, Yazi, Zellij, MangoWM binds)
└── configs/                   # Dotfiles originais importados dinamicamente pelo Home Manager
    ├── fastfetch/
    ├── yazi/
    ├── zellij/
    └── zsh/
```

## Como implantar e aplicar a configuração

Como a configuração utiliza **Nix Flakes**, os arquivos do repositório **devem ser rastreados pelo Git** para que o Nix consiga lê-los e avaliá-los.

Siga os passos abaixo a partir deste diretório (`/home/gsouza/.gemini/antigravity/scratch/nixos-config`):

### 1. Inicializar o Git e Adicionar os Arquivos
```bash
git init
git add .
```

### 2. Validar a Configuração (Dry-run)
Para simular a ativação sem alterar arquivos reais de sistema:
```bash
nix flake check
nixos-rebuild dry-activate --flake .#default
```

### 3. Aplicar as Configurações no Sistema
Para recompilar o sistema e ativar as novas configurações:
```bash
sudo nixos-rebuild switch --flake .#default
```

## Configurações Especiais Aplicadas
* **Layout de Teclado:** Layout ABNT2 (`br`) mapeado globalmente para console físico TTY e compositor Wayland.
* **Noctalia Greeter:** Tela de login automatizada via `greetd` executando o greeter do Noctalia dentro do compositor minimalista `cage`.
* **Desbloqueio de Keyring:** Configuração automática PAM para liberação do GNOME Keyring de maneira transparente após a inserção da senha do usuário no login.
* **Atalhos do MangoWM:** Todos os atalhos de janelas do Hyprland originais foram adaptados para a sintaxe do MangoWM (`spawn_shell`), acionando os comandos IPC do Noctalia de forma idêntica.
