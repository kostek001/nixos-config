{ config, ... }:

{
  imports = [
    ./nextcloud.nix
    ./shells.nix
    ./software.nix
  ];

  ## HOME MANAGER
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/homeManager-config.key" ];

  programs.git.enable = true;

  # Disable bluetooth headset automatic profile switch
  xdg.configFile."wireplumber/wireplumber.conf.d/11-bluetooth-headset-policy.conf".text = ''
    wireplumber.settings = {
      bluetooth.autoswitch-to-headset-profile = false
    }
  '';

  khome.gnome.enable = true;
}
