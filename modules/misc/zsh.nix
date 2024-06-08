{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kostek001.misc.zsh;
in
{
  options.kostek001.misc.zsh = {
    enable = mkEnableOption "Zsh";
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      syntaxHighlighting = {
        enable = true;
        styles = {
          "command" = "fg=4,bold";
          "builtin" = "fg=4,bold";
          "alias" = "fg=4,bold,underline";
          "precommand" = "fg=6,bold";
        };
      };
      autosuggestions.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "bira";
      };
    };
  };
}
