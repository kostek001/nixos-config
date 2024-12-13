{ pkgs, ... }:

{
  imports = [
    ../../../kostek/home/config/nextcloud.nix
  ];

  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    thunderbird
  ];
}
