{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./packages.nix
    ./intel-gpu.nix
    ./podman.nix
  ];

  # 1. Nix Settings & Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ 
      "https://noctalia.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [ 
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    auto-optimise-store = true;
    # Increase the download buffer size to avoid timeouts (512 MB)
    download-buffer-size = 536870912;
  };

  # Automatic garbage collection (disabled to avoid conflict with nh.clean)
  nix.gc = {
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # 2. Bootloader and Kernel Latency Settings
  boot = {
    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    loader.efi.canTouchEfiVariables = true;

    # Clean temporary files from the SSD on every boot
    tmp.cleanOnBoot = true;

    # Load the i2c-dev driver to allow brightness control via ddcutil
    kernelModules = [ "i2c-dev" ];

    # Low latency and priority adjustments for RAM/Kernel
    kernel.sysctl = {
      # Swappiness of 100 forces compression in ZRAM instead of ejecting page cache from the FS
      "vm.swappiness" = 100;
      # Disable watermark boost to mitigate I/O stutters during memory allocation peaks
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      # Prevent aggressive swap pre-allocation (ZRAM optimization)
      "vm.page-cluster" = 0;
    };
  };

  # Enable compressed swap in RAM (ZRAM)
  zramSwap.enable = true;

  # Enable the I2C bus for monitor hardware control
  hardware.i2c.enable = true;

  # Passwordless sudo rules (NOPASSWD) for basic system commands
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          { command = "/run/current-system/sw/bin/shutdown"; options = [ "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/reboot"; options = [ "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/poweroff"; options = [ "NOPASSWD" ]; }
          { command = "/run/wrappers/bin/mount"; options = [ "NOPASSWD" ]; }
          { command = "/run/wrappers/bin/umount"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  };

  # 3. Networking & Locale
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" ];
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = "8.8.8.8";
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # 4. Keyboard Layout (ABNT2)
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # 5. User Configuration (Gabriel)
  users.users.gsouza = {
    isNormalUser = true;
    description = "Gabriel de Souza";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "i2c" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Enable MangoWM system module
  programs.mango.enable = true;

  # Enable dconf for GTK themes (nwg-look / gsettings)
  programs.dconf.enable = true;

  # Enable Steam with 32-bit hardware support & firewall rules
  programs.steam.enable = true;

  # Enable XWayland support
  programs.xwayland.enable = true;

  # Enable nh (Nix Helper) for cleaner and faster rebuilds/Garbage Collection
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/gsouza/.config/nixos";
  };

  # System state version
  system.stateVersion = "24.05";
}
