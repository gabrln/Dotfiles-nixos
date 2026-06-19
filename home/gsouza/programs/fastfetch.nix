{ config, pkgs, ... }:

{
  xdg.configFile."fastfetch".source = ./../../../configs/fastfetch;
}
