{ pkgs, ... }:

{
  imports = [
    (import ../../users/kostek/default.nix { username = "kostek"; fullname = "Kostek"; })
  ];

  knix.misc.virtualisation.enable = true;
  knix.users.kostek.vr.enable = true;
  knix.users.kostek.pentesting.enable = true;

  home-manager.users.kostek = { ... }: {
    khome.games.vr.enable = true;
    khome.software.editing.enable = true;
    khome.software.modeling.enable = true;
    home.packages = with pkgs; [ ollama-cuda ];
  };

  virtualisation.podman.enable = true;
  environment.systemPackages = with pkgs; [ podman-tui podman-compose ];
  hardware.nvidia-container-toolkit.enable = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  knix.boot.plymouth.enable = false;

  users.users.kostek.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOcXWhr2G4lVo1rfe45hfwcka9OelTroFc+1FJJNA9M kostek@dellome"
  ];

  services.tailscale.enable = true;
  services.zerotierone.enable = true;
}
