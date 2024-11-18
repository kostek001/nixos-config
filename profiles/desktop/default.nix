{ config, lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
  ];

  ## BOOT
  knix.boot.plymouth.enable = true;

  ## NETWORKING
  networking.networkmanager.enable = true;
  knix.privileged.groups = [ "networkmanager" ];

  ## SOUND
  security.rtkit.enable = lib.mkDefault config.services.pipewire.enable;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  ## HARDWARE
  hardware.bluetooth.enable = true;

  ## DE
  knix.desktop.gnome.enable = true;
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; }) ];

  ## LOCALE
  # TODO: change this to something else
  i18n.defaultLocale = "pl_PL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  ## SOFTWARE
  programs.firefox = {
    enable = true;
    # Use file picker from DE
    preferences."widget.use-xdg-desktop-portal.file-picker" = 1;
  };

  environment.systemPackages = with pkgs; [
    libreoffice
    vlc
    qpwgraph
    easyeffects
  ];
  services.flatpak.enable = true;

  # Expand user tmp
  # services.logind.extraConfig = "RuntimeDirectorySize=40%";

  # From nix-community/srvos
  # improve desktop responsiveness when updating the system
  nix.daemonCPUSchedPolicy = "idle";
}
