{ configType }: { ... }:

{
  imports = [
    (import ./normal/home.nix { inherit configType; })
    (import ./full/home.nix { inherit configType; })
  ];

  programs.git = {
    enable = true;
    userName = "kostek001";
    userEmail = "kostek0020@gmail.com";
  };

  kostek001.desktop.plasma.enable = true;

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
}
