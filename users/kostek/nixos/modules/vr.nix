{ config, pkgs, lib, inputs, ... }:
with lib;

let
  cfg = config.knix.users.kostek.vr;
in
{
  options.knix.users.kostek.vr = {
    enable = mkEnableOption "VR";
  };

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  config = mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      package = pkgs.wivrn.override { cudaSupport = true; };
      openFirewall = false;
      defaultRuntime = true;
      autoStart = false;
      config = {
        enable = false;
        # TODO: Move to home manager module
        json = {
          bitrate = 150 * 1000000;
          scale = 0.8;
          application = [ pkgs.wlx-overlay-s ];
          tcp_only = true;
        };
      };
    };

    environment.systemPackages = [ pkgs.monado-vulkan-layers ];
    hardware.graphics.extraPackages = [ pkgs.monado-vulkan-layers ];

    # SlimeVR
    # environment.systemPackages = [ inputs.kostek001-pkgs.packages.${pkgs.system}.slimevr ];
    # networking.firewall.allowedTCPPorts = [ 21110 ];
    # networking.firewall.allowedUDPPorts = [ 35903 6969 ];
  };
}
