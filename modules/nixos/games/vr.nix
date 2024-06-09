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
      package = inputs.lemonake.packages.${pkgs.system}.wivrn;
      highPriority = true;
      defaultRuntime = true;
      monadoEnvironment = {
        XRT_COMPOSITOR_LOG = "debug";
        XRT_PRINT_OPTIONS = "on";
        IPC_EXIT_ON_DISCONNECT = "off";
      };
    };

    hardware.opengl.extraPackages = [
      inputs.lemonake.packages.${pkgs.system}.monado-vulkan-layers
    ];
  };
}
