{ config, pkgs, lib, inputs, ... }:
with lib;

let
  cfg = config.kostek001.games.vr;
in
{
  options.kostek001.games.vr = {
    enable = mkEnableOption "VR";
  };

  imports = [
    inputs.lemonake.nixosModules.wivrn
  ];

  config = mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      package = inputs.lemonake.packages.${pkgs.system}.wivrn.override { cudaSupport = true; };
      openFirewall = true;
      defaultRuntime = true;
      autoStart = false;
      config = {
        enable = true;
        json = {
          application = [ pkgs.wlx-overlay-s ];
          tcp_only = true;
        };
      };
    };

    hardware.graphics.extraPackages = [
      inputs.lemonake.packages.${pkgs.system}.monado-vulkan-layers
    ];

    # SlimeVR
    environment.systemPackages = with pkgs; [ inputs.kostek001-pkgs.packages.${pkgs.system}.slimevr ];
    networking.firewall.allowedTCPPorts = [ 21110 ];
    networking.firewall.allowedUDPPorts = [ 35903 6969 ];
  };
}
