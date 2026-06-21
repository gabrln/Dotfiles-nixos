# NixOS Config (MangoWM + Noctalia)

Esta é a configuração declarativa do NixOS para o usuário `gsouza`, integrando o compositor **MangoWM** e o ambiente gráfico **Noctalia Shell**.

---

## 🚀 Estrutura de Ramificações (Branches)

Este repositório é gerenciado através de duas ramificações principais no Git:
*   **`main` (Estável):** Contém a configuração de base estável do sistema.
*   **`experimental` (Desenvolvimento/Performance):** Contém otimizações agressivas de desempenho de kernel, áudio de baixíssima latência (Pro-Audio), virtualização via Podman, regras administrativas do Sudo sem senha e drivers de vídeo avançados.

---

## 📂 Estrutura do Repositório

```text
nixos-config/
├── flake.nix                       # Entrada do Nix Flake com canais (26.05) e inputs
├── flake.lock                      # Travamento de versões exatas dos canais e flakes
├── README.md                       # Documentação do sistema
├── hosts/
│   └── default/                    # Configurações em nível de sistema (Root/NixOS)
│       ├── default.nix             # Entrada do host (ZRAM, Kernel sysctl, GC, Sudo, Locales)
│       ├── hardware-configuration.nix # Mapeamento físico dos discos (gerado pelo sistema)
│       ├── services.nix            # Pipewire, greetd, earlyoom, pam limits, bluetooth, etc.
│       ├── packages.nix            # Pacotes de sistema (systemPackages globais)
│       ├── intel-gpu.nix           # Módulo isolado de drivers e aceleração gráfica Intel
│       └── podman.nix              # Módulo de virtualização e compatibilidade Docker
└── home/
    └── gsouza/                     # Configurações em nível de usuário (Home Manager)
        ├── home.nix                # Entrada do Home Manager (MIME Apps, Variáveis de Sessão)
        ├── programs/               # Módulos de aplicativos e TUIs
        │   ├── default.nix         # Importações dos sub-módulos de programas
        │   ├── kitty.nix           # Terminal Kitty (Fonte JetBrainsMono 10.5)
        │   ├── zsh.nix             # Zsh aliases, keybindings e integração FZF/zvm
        │   ├── yazi.nix            # Yazi File Manager (com bindings de backspace e flavor Noctalia)
        │   ├── nvim.nix            # Editor Neovim (básico via initLua + clipboard)
        │   └── zellij.nix          # Multiplexador Zellij
        └── wayland/                # Módulos gráficos do compositor
            ├── default.nix         # Importador gráfico
            ├── mango.nix           # Configuração de atalhos e comp. do MangoWM
            └── noctalia.nix        # Shell e painel dinâmico do Noctalia
```

---

## ⚙️ Otimizações Aplicadas (Branch `experimental`)

### 1. Desempenho e Drivers de Vídeo (GPU Intel Iris Xe)
*   **Carregamento de Kernel Precoce:** Adicionado driver `i915` ao `boot.initrd.kernelModules` para ativação direta no stage 1, eliminando cintilações no Wayland.
*   **Drivers Modernos:** Uso exclusivo do `intel-media-driver` (iHD) para decodificação em hardware em Tiger Lake (Gen 12), removendo o driver legado `intel-vaapi-driver` que induzia falhas de decodificação.
*   **Forçamento Vulkan:** Definição da variável de ambiente global `VK_ICD_FILENAMES` apontando para o arquivo ICD oficial da Intel.

### 2. Estabilidade e Paginação de Memória (ZRAM + earlyoom)
*   **ZRAM Swap:** Compactação em RAM ativa para aliviar estresse em sistemas de 16GB.
*   **Kernel Tweaks:** Configurado `vm.swappiness = 100` para forçar o kernel a compactar no ZRAM preferencialmente em vez de ejetar o cache de disco (evitando travamentos de sistema de arquivos) e desativado *watermark boost* para mitigar stutters de I/O.
*   **EarlyOOM Daemon:** Configurado para encerrar processos em consumo crítico (RAM livre < 5%) com alertas gráficos visíveis.

### 3. Áudio de Baixa Latência & Estabilidade (Pipewire + Wireplumber)
*   **PAM Limits (Pro-Audio):** Permissão de bloqueio físico ilimitado de memória RAM (`memlock = unlimited`) para o grupo de áudio.
*   **Configurações do Pipewire:** Quantum estável fixado em `256/48000` (latência de ~5ms) no relógio e na emulação do PulseAudio (resolvendo cliques/estalos sonoros em jogos via Proton/Wine).
*   **Desativação de Suspensão:** Dispositivos ALSA e Bluetooth configurados para não entrarem em suspensão temporária no Wireplumber.

### 4. Virtualização (Podman + Socket API)
*   Substituição do Docker pelo **Podman** de maneira limpa.
*   Habilitação de `dockerCompat = true` e `dockerSocket.enable = true` para garantir que o socket local interaja transparentemente com ferramentas que requerem a API Docker original (como extensões Devcontainers no VSCode).

### 5. Conveniência Administrativa (Sudo NOPASSWD)
*   Regras de Sudo flexibilizadas especificamente para o grupo `wheel` nos comandos de energia e discos: `shutdown`, `reboot`, `poweroff`, `mount` e `umount`.

---

## 🛠️ Como Implantar e Reconstruir

Como as configurações utilizam **Nix Flakes**, todos os arquivos criados ou modificados **devem ser rastreados pelo Git** antes de acionar a reconstrução, sob o risco do Nix ignorar as mudanças.

### 1. Clonar ou Acessar o Repositório
```bash
cd /home/gsouza/.config/nixos
```

### 2. Selecionar a Branch Desejada
*   **Para a versão estável:**
    ```bash
    git checkout main
    ```
*   **Para a versão experimental (otimizada):**
    ```bash
    git checkout experimental
    ```

### 3. Rastrear Alterações no Git
A cada nova alteração ou arquivo criado:
```bash
git add .
```

### 4. Reconstruir e Aplicar as Configurações
*   **Validar Sintaxe (Sem aplicar alterações):**
    ```bash
    nix flake check --accept-flake-config
    ```
*   **Aplicar e Tornar Padrão no Próximo Boot:**
    ```bash
    sudo nixos-rebuild switch --flake .#default --accept-flake-config
    ```
*   **Apenas Testar (Sem adicionar ao menu do GRUB):**
    ```bash
    sudo nixos-rebuild test --flake .#default --accept-flake-config
    ```
