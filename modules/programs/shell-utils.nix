{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.programs.shell-utils;
in
{
  options.kostek001.programs.shell-utils = {
    enable = mkEnableOption "Shell utils";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eza
      bat
      btop
    ];
    environment.shellAliases = {
      ls = "eza";
      ll = "eza -la";
      cat = "bat";
      htop = "btop";
    };
  };
}
