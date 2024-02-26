{ config, lib, pkgs, username, ... }:
with lib;

let
  cfg = config.kostek001.programs.obs;
in
{
  options.kostek001.programs.obs = {
    enable = mkEnableOption "OBS Studio";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = { ... }: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [
          obs-studio-plugins.droidcam-obs
        ];
      };
    };

    # For virtual camera
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  };
}
