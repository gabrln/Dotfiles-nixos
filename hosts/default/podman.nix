{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;                     # Limpeza semanal automática de containers/imagens órfãos
      dockerCompat = true;                         # Cria link simbólico para mapear o comando `docker` para o Podman
      dockerSocket.enable = true;                  # Habilita o socket do Docker para compatibilidade (Devcontainers, VSCode, etc.)
      defaultNetwork.settings.dns_enabled = true; # Necessário para comunicação de nomes de serviços no podman-compose
    };
  };
}
