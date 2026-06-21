{ config, pkgs, ... }:

{
  # Força o carregamento do driver i915 no primeiro estágio do boot (stage 1)
  # Isso previne cintilações gráficas ao carregar o MangoWM/Wayland
  boot.initrd.kernelModules = [ "i915" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Fundamental para Steam, Wine e Proton rodarem jogos 32-bit
    extraPackages = with pkgs; [
      intel-media-driver   # Driver iHD (decodificação de mídia moderna Gen 12)
      libva-vdpau-driver
      libvdpau-va-gl       # Ponte de compatibilidade VDPAU para VAAPI
      vpl-gpu-rt           # Runtime OneVPL para processamento gráfico em Gen 12+
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
    ];
  };
}
