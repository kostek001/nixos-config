{ pkgs, ... }:
{
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
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "bira";
    };
    history.ignoreDups = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      # {
      #   name = "theme-bira";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "oh-my-fish";
      #     repo = "theme-bira";
      #     rev = "342830006df206ab93184f47ec1e102049ab7ffb";
      #     hash = "sha256-rlhpdI5BswNIvf23TH0oJ88ItpIrp9hX3QV7sQwoF0o=";
      #   };
      # }
    ];
  };
}
