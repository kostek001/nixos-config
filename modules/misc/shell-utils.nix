{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.knix.programs.shell-utils;
in
{
  options.knix.programs.shell-utils = {
    enable = mkEnableOption "Shell utils";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eza
      bat
    ];
    environment.shellAliases = {
      ls = "eza";
      ll = "eza -la";
    };
  };
}
