{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.knix.hardware.opentabletdriver;
in
{
  options.knix.hardware.opentabletdriver = {
    enable = mkEnableOption "OpenTabletDriver";
  };

  config = mkIf cfg.enable {
    systemd.user.services.opentabletdriver = {
      description = "Open source, cross-platform, user-mode tablet driver";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.opentabletdriver}/bin/otd-daemon";
        Restart = "on-failure";
      };
    };

    environment.systemPackages = with pkgs; [ opentabletdriver ];

    # UDEV rules for Huion HS611
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ENV{ID_USB_INTERFACE_NUM}="$attr{bInterfaceNumber}"
  
      #SUBSYSTEM=="usb", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006f", ENV{ID_USB_INTERFACE_NUM}=="01", ATTR{authorized}="0"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006f", ENV{ID_USB_INTERFACE_NUM}=="02", ATTR{authorized}="0"

      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006f", ENV{ID_USB_INTERFACE_NUM}=="00", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006f", MODE="0666"
      SUBSYSTEM=="input", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006f", ENV{ID_USB_INTERFACE_NUM}=="00", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
