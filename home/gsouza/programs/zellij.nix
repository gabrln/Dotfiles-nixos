{ config, pkgs, ... }:

{
  xdg.configFile."zellij".source = ./../../../configs/zellij;
}
