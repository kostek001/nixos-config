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
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # NVIDIA drivers are unfree.
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
      ];

    # Tell Xorg to use the nvidia driver
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      #open = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
