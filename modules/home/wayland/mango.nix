{ config, ... }:

{
  # Enable MangoWM
  wayland.windowManager.mango.enable = true;

  # Map MangoWM scripts directory (mutable - editable without rebuild)
  xdg.configFile."mango/scripts".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/mango/scripts";

  # Mutable MangoWM config (editable without rebuild)
  xdg.configFile."mango/config.conf".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/mango/mango.conf";
}
