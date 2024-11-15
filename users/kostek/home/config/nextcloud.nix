{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nextcloud-client
  ];

  xdg.configFile."autostart/Nextcloud.desktop".text = ''
    [Desktop Entry]
    Name=Nextcloud
    GenericName=File Synchronizer
    Exec=nextcloud --background
    Terminal=false
    Icon=Nextcloud
    Categories=Network
    Type=Application
    StartupNotify=false
    X-GNOME-Autostart-enabled=true
    X-GNOME-Autostart-Delay=10
  '';
}
