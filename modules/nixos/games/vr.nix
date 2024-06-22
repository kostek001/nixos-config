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
    ../../../pkgs/games/wivrn/module.nix
  ];

  config = mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      # package = inputs.lemonake.packages.${pkgs.system}.wivrn.override { cudaSupport = true; };
      package = (pkgs.callPackage ../../../pkgs/games/wivrn/package.nix { }).override { cudaSupport = true; };
      openFirewall = true;
      highPriority = true;
      defaultRuntime = true;
      monadoEnvironment = {
        XRT_COMPOSITOR_COMPUTE = "1";
        XRT_COMPOSITOR_LOG = "debug";
        XRT_LOG = "debug";
      };
    };

    hardware.graphics.extraPackages = [
      inputs.lemonake.packages.${pkgs.system}.monado-vulkan-layers
    ];

    environment.systemPackages = with pkgs; [
      xrgears
      wlx-overlay-s
    ];
  };
}
