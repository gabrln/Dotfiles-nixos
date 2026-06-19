{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.mango.hmModules.mango
    ./programs
    ./wayland
  ];

  # Home Manager identity
  home.username = "gsouza";
  home.homeDirectory = "/home/gsouza";
  home.stateVersion = "24.05";
}
