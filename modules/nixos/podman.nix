{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;                     # Weekly automatic cleanup of orphan containers/images
      dockerCompat = true;                         # Create symlink mapping docker command to podman
      dockerSocket.enable = true;                  # Enable Docker socket for compatibility (Devcontainers, VSCode, etc.)
      defaultNetwork.settings.dns_enabled = true; # Required for service name communication in podman-compose
    };
  };
}
