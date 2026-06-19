{ config, pkgs, ... }:

{
  xdg.configFile."yazi/yazi.toml".source = ./../../../configs/yazi/yazi.toml;
  xdg.configFile."yazi/keymap.toml".source = ./../../../configs/yazi/keymap.toml;
  xdg.configFile."yazi/opener.toml".source = ./../../../configs/yazi/opener.toml;
  xdg.configFile."yazi/theme.toml".source = ./../../../configs/yazi/theme.toml;
}
