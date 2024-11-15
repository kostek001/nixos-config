{ config, lib, pkgs, inputs, ... }:
with lib;

let
  cfg = config.knix.boot.loader.lanzaboote;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.knix.boot.loader.lanzaboote = {
    enable = mkEnableOption "Lanzaboote";
  };

  config = mkIf cfg.enable {
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.loader = {
      timeout = 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = false;
        editor = false;
        consoleMode = "auto";
      };
    };
  };
}
