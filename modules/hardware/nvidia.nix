{ config, lib, pkgs, ... }:
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

      open = mkDefault true;

      # Required for suspend, due to firmware bugs
      powerManagement.enable = mkDefault true;

      nvidiaSettings = mkDefault false;

      package = mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
    };

    boot.extraModprobeConfig = "options nvidia " + lib.concatStringsSep " " (
      [
        # Enable some PAT support (it improves performance)
        "NVreg_UsePageAttributeTable=1"
      ]
      # Fix for stutters (use propertiary drivers)
      # see issues https://github.com/NVIDIA/open-gpu-kernel-modules/issues/538, 
      # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/693 
      ++ optionals (!config.hardware.nvidia.open) [ "NVreg_EnableGpuFirmware=0" ]
    );

    systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = mkIf config.hardware.nvidia.powerManagement.enable "false";

    # Fixes gnome suspending after waking up from automatic suspend
    systemd.services."gnome-suspend" = mkIf (config.services.xserver.desktopManager.gnome.enable && config.hardware.nvidia.powerManagement.enable) {
      description = "suspend gnome shell";
      before = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-suspend.service"
        "nvidia-hibernate.service"
      ];
      wantedBy = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell'';
      };
    };
    systemd.services."gnome-resume" = mkIf (config.services.xserver.desktopManager.gnome.enable && config.hardware.nvidia.powerManagement.enable) {
      description = "resume gnome shell";
      after = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-resume.service"
      ];
      wantedBy = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell'';
      };
    };


    environment.variables = {
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Without this nouveau may attempt to be used instead (despite being blacklisted)
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # disable this because it breaks prusa-slicer somehow
      # Hardware cursors are currently broken on nvidia
      # WLR_NO_HARDWARE_CURSORS = "1";
    };

    # Override cudaSupport on specific packages, instead of globally
    # `nixpkgs.config.cudaSupport = true;`
    nixpkgs.overlays = [
      (final: prev: {
        wivrn = prev.wivrn.override { cudaSupport = true; };
        obs-studio = prev.obs-studio.override { cudaSupport = true; };
        blender = prev.blender.override { cudaSupport = true; };
      })
    ];
  };
}
