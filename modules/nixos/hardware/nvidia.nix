{ config, lib, ... }:
with lib;

let
  cfg = config.kostek001.hardware.nvidia;
in
{
  options.kostek001.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA drivers";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
      ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;
      nvidiaSettings = true;
      #open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
