{ config, lib, pkgs, inputs, ... }:
with lib;

let
  cfg = config.kostek001.boot.loader.lanzaboote;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.kostek001.boot.loader.lanzaboote = {
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
        configurationLimit = 10;
        editor = false;
      };
    };
  };
}
