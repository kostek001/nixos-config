{ pkgs, ... }:

{
  services.ratbagd.enable = true;
  hardware.keyboard.qmk.enable = true;

  environment.systemPackages = with pkgs; [
    piper # GTK app for configuring mices
  ];
}
