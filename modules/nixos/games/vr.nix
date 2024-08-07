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
      autoStart = true;
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

    environment.systemPackages = with pkgs; [
      xrgears
      #wlx-overlay-s # Build failed: 0.4.2
    ];
  };
}
