{ config, pkgs, inputs, ... }:

{
  # Audio (Pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Hardware & Services required by Noctalia / Wayland
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Greetd Login Manager with Noctalia Greeter (running inside Cage kiosk)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -m last -- ${inputs.noctalia-greeter.packages.${pkgs.system}.default}/bin/noctalia-greeter-session";
        user = "greeter";
      };
    };
  };

  # Desbloqueio automático do GNOME Keyring no login via greetd
  security.pam.services.greetd.enableGnomeKeyring = true;

  # XDG Portals (necessário para launcher do Noctalia)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
