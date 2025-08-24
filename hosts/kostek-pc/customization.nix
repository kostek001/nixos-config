{ pkgs, ... }:

{
  imports = [
    (import ../../users/kostek/default.nix { username = "kostek"; fullname = "Kostek"; })
  ];

  knix.boot.plymouth.enable = false;
  knix.misc.virtualisation.enable = true;
  knix.users.kostek.vr.enable = true;
  knix.users.kostek.pentesting.enable = true;

  services.openssh.enable = true;
  services.zerotierone.enable = true;
  programs.partition-manager.enable = true;
  hardware.opentabletdriver.enable = true;

  # User config
  home-manager.users.kostek = { ... }: {
    khome.games.vr.enable = true;
    khome.software.editing.enable = true;
    khome.software.modeling.enable = true;
    home.packages = with pkgs; [ mixxx ];
  };
  users.users.kostek.openssh.authorizedKeys.keys = [
    (import ../identities.nix).keys."kostek@dellome"
    (import ../identities.nix).keys."kostek@kostek-pixel"
  ];

  # Podman
  virtualisation.podman.enable = true;
  environment.systemPackages = with pkgs; [ podman-tui podman-compose ];
  hardware.nvidia-container-toolkit.enable = true;

  # Scheduler
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
