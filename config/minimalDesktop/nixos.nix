{ configType }: { lib, pkgs, inputs, username, ... }:

{
  config = lib.mkIf configType.minimalDesktop {
    ## SOUND
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };
    programs.noisetorch.enable = true;

    ## HID
    services.ratbagd.enable = true;
    hardware.keyboard.qmk.enable = true;

    ## BOOT
    kostek001.boot.plymouth.enable = true;

    ## LOGON
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    ## DESKTOP ENVIRONMENT
    kostek001.desktop.plasma.enable = true;
    fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; }) ];

    ## OTHER
    kostek001.hardware.opentabletdriver.enable = true;
    kostek001.hardware.platformio.enable = true;
    hardware.bluetooth.enable = true;
    # ADB
    programs.adb.enable = true;
    users.users.${username}.extraGroups = [ "adbusers" ];

    ## PKGS
    services.flatpak.enable = true;
    programs.firefox = {
      enable = true;
      # Use file picker from DE
      preferences."widget.use-xdg-desktop-portal.file-picker" = 1;
      package = inputs.firefox.packages.${pkgs.system}.firefox-beta-bin;
    };
    environment.systemPackages = with pkgs; [
      piper
      # For Ark
      p7zip
      unar

      # DEFAULT
      libreoffice
      vlc
      qpwgraph
      kdePackages.filelight
    ];
  };
}
