{ config, lib, inputs, vars, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;

  boot.initrd.supportedFilesystems = [ "btrfs" ];

  # Preservação de dados essenciais a nível de sistema
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
      "/var/lib/containers" # Persiste imagens/dados do Podman e Docker
    ];
    files = [
      "/etc/machine-id"
      "/etc/shadow"
      "/etc/passwd"
      "/etc/group"
      "/etc/subuid"
      "/etc/subgid"
    ];
  };

  # Vinculação das pastas persistentes da home do usuário
  environment.persistence."/persist".users.${vars.userName} = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Projects" # Seus projetos e código
      ".config/nixos" # O próprio repositório para podermos rodar nh os switch
      ".local/share/Steam"
      ".steam"
      ".mozilla"
    ];
  };
}
