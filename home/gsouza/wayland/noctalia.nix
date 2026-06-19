{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      shell = {
        launch_apps_as_systemd_services = true;
        panel = {
          shadow = false;
        };
      };
      bar = {
        main = {
          shadow = false;
          contact_shadow = false;
        };
      };
      dock = {
        shadow = false;
      };
    };
  };

  # Noctalia Templates Configuration for Auto-Theming
  xdg.configFile."noctalia/templates.toml".text = ''
    [theme.templates]
    enable_builtin_templates = true
    enable_community_templates = true
    builtin_ids = [ "kitty", "starship", "mango" ]
    community_ids = [ "yazi" ]
  '';
}
