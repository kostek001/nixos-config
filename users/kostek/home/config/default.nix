{ config, ... }:

{
  imports = [
    ./nextcloud.nix
    ./shells.nix
    ./software.nix
  ];

  ## HOME MANAGER
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/homeManager-config.key" ];

  programs.git = {
    enable = true;
    userName = "kostek001";
    userEmail = "kostek0020@gmail.com";
  };

  # Disable bluetooth headset automatic profile switch
  xdg.configFile."wireplumber/wireplumber.conf.d/11-bluetooth-headset-policy.conf".text = ''
    wireplumber.settings = {
      bluetooth.autoswitch-to-headset-profile = false
    }
  '';
}
