# Configuração Declarativa NixOS (MangoWM + Noctalia)

Este repositório contém a configuração declarativa do sistema operacional NixOS para o usuário gsouza, estruturada utilizando Nix Flakes e Home Manager. A interface gráfica é composta pelo compositor MangoWM e pela suite Noctalia Shell.

## Estrutura do Repositório

```text
nixos-config/
├── flake.nix                       # Ponto de entrada do Nix Flake com canais (26.05) e inputs
├── flake.lock                      # Travamento de versões exatas de dependências externas
├── README.md                       # Guia técnico de instalação e arquitetura
├── hosts/
│   └── default/                    # Configurações a nível de sistema (Root/System)
│       ├── default.nix             # Entrada do host (ZRAM, Kernel sysctl, GC, Sudo, Locales)
│       ├── hardware-configuration.nix # Mapeamento de hardware gerado pelo instalador do NixOS
│       ├── services.nix            # Pipewire, greetd, earlyoom, pam limits, bluetooth
│       ├── packages.nix            # Pacotes de sistema globais
│       ├── intel-gpu.nix           # Drivers e aceleração de vídeo Intel Iris Xe
│       └── podman.nix              # Virtualização de contêineres compatível com Docker
└── home/
    └── gsouza/                     # Configurações a nível de usuário (Home Manager)
        ├── home.nix                # Entrada do Home Manager (Temas, MIME Apps, ativações)
        ├── programs/               # Módulos de programas de terminal e editores
        │   ├── default.nix         # Importações do diretório de programas
        │   ├── kitty.nix           # Emulador de terminal Kitty
        │   ├── zsh.nix             # Configuração do Zsh, aliases e FZF
        │   ├── yazi.nix            # Gerenciador de arquivos de terminal Yazi
        │   ├── nvim.nix            # Configuração do Neovim (Nixvim sem autocompletar popups)
        │   └── zellij.nix          # Multiplexador de terminal Zellij
        └── wayland/                # Módulos do servidor gráfico
            ├── default.nix         # Importações de Wayland
            ├── mango.nix           # Configuração de atalhos e regras do MangoWM
            └── noctalia.nix        # Integração do shell e painéis do Noctalia
```

## Requisitos de Hardware e Otimizações

A configuração está otimizada para o processador Intel com placa integrada Iris Xe Graphics e 16GB de memória RAM:
1. **Vídeo (Intel Iris Xe):** Carregamento precoce do driver de kernel `i915` no initrd para evitar cintilação da tela. Utilização do driver `intel-media-driver` (iHD) para decodificação em hardware e definição de variáveis do Vulkan (`VK_ICD_FILENAMES`).
2. **Memória e ZRAM:** Compactação agressiva via ZRAM habilitada como swap principal. Parâmetros de kernel `vm.swappiness = 100`, `vm.watermark_boost_factor = 0` e `vm.page-cluster = 0` para evitar gargalos de escrita e leitura em SSD.
3. **Áudio de Baixa Latência (Pro-Audio):** Limites de RAM (`memlock`) configurados como ilimitados para o grupo `audio`. Pipewire configurado com relógio de 48kHz e tamanho de bloco (quantum) estável de 256 amostras (latência de ~5.3ms). Wireplumber com suspensão automática de ALSA e Bluetooth desativada.
4. **Virtualização:** Podman habilitado com socket de emulação do Docker para compatibilidade transparente com Devcontainers e ferramentas Docker originais.

## Guia de Instalação em Nova Máquina

Siga os passos abaixo para implantar esta configuração a partir de uma instalação limpa utilizando a imagem ISO do NixOS.

### 1. Preparação e Particionamento

Dê boot na máquina utilizando o instalador do NixOS. Execute o particionamento utilizando `gdisk` ou `parted`.
O esquema recomendado utiliza Btrfs sobre GPT:
*   `/dev/sdX1`: EFI System Partition (mínimo 512MB, formatada em FAT32/vfat).
*   `/dev/sdX2`: Partição Root (formatada em Btrfs).

Crie os subvolumes Btrfs desejados (exemplo: `root`, `home`, `nix`):
```bash
mount /dev/sdX2 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
umount /mnt
```

Monte os subvolumes na estrutura de instalação:
```bash
mount -o subvol=root,compress=zstd,noatime /dev/sdX2 /mnt
mkdir -p /mnt/boot /mnt/home /mnt/nix
mount /dev/sdX1 /mnt/boot
mount -o subvol=home,compress=zstd,noatime /dev/sdX2 /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/sdX2 /mnt/nix
```

### 2. Geração da Configuração de Hardware

Gere a configuração física da máquina sob o diretório temporário:
```bash
nixos-generate-config --root /mnt
```
Isso criará os arquivos `/mnt/etc/nixos/configuration.nix` e `/mnt/etc/nixos/hardware-configuration.nix`.

### 3. Clonar a Configuração Declarativa

Clone este repositório para o diretório de destino do usuário Gabriel:
```bash
nix-shell -p git
git clone https://github.com/gsouza/nixos-config.git /mnt/home/gsouza/.config/nixos
```

Substitua o arquivo de hardware do repositório pelo arquivo gerado pelo instalador na etapa anterior:
```bash
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/gsouza/.config/nixos/hosts/default/hardware-configuration.nix
```

### 4. Executar a Instalação Inicial

Navegue até o diretório da configuração e execute o comando de instalação apontando para a flake `nixos`:
```bash
cd /mnt/home/gsouza/.config/nixos
nixos-install --flake .#nixos
```

Ao finalizar, defina a senha do usuário `gsouza` quando solicitado, remova a mídia de boot e reinicie a máquina.

---

## Gerenciamento e Reconstrução (Switch)

Após a inicialização do sistema, todas as modificações nas configurações devem ser realizadas no repositório local e aplicadas utilizando os comandos Nix Flake.

### Branches do Repositório
*   `main`: Contém a ramificação com componentes base estáveis.
*   `experimental`: Contém melhorias de desempenho de latência de kernel, otimizações de vídeo, regras NOPASSWD de sudo e virtualização avançada.

### Comandos de Administração

1.  **Navegar ao repositório:**
    ```bash
    cd ~/.config/nixos
    ```

2.  **Rastrear arquivos no Git:**
    O Nix Flake ignora qualquer arquivo que não esteja rastreado pelo Git. Antes de tentar reconstruir, adicione novos arquivos ou modificações:
    ```bash
    git add -A
    ```

3.  **Validar sintaxe (Dry run / Flake check):**
    ```bash
    nix flake check --accept-flake-config
    ```

4.  **Aplicar configurações e atualizar inicializador (Rebuild Switch):**
    ```bash
    nh os switch
    ```

5.  **Testar alterações temporariamente (Sem gravar no menu de boot):**
    ```bash
    nh os test
    ```
