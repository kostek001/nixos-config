{ config, lib, ... }:
with lib;

let
  cfg = config.knix.hardware.nvidia;
in
{
  options.knix.hardware.nvidia = {
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

      # Temporary fix for https://github.com/NVIDIA/open-gpu-kernel-modules/issues/538
      open = false;

      # Required for suspend, due to firmware bugs
      powerManagement.enable = true;

      nvidiaSettings = false;

      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    boot.extraModprobeConfig = "options nvidia " + lib.concatStringsSep " " [
      # Enable some PAT support (it improves performance)
      "NVreg_UsePageAttributeTable=1"
      # Temporary fix for https://github.com/NVIDIA/open-gpu-kernel-modules/issues/538
      "NVreg_EnableGpuFirmware=0"
    ];

    environment.variables = {
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Without this nouveau may attempt to be used inestead (despite being blacklisted)
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # disable this because it breaks prusa-slicer somehow
      # Hardware cursors are currently broken on nvidia
      # WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
