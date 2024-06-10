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
      # package = (inputs.lemonake.packages.${pkgs.system}.wivrn.overrideAttrs (oldAttrs: {
      #   version = "de4715cd864043368707bb7d6b81dd059a3925ce";
      #   src = oldAttrs.src.override {
      #     rev = "de4715cd864043368707bb7d6b81dd059a3925ce";
      #     hash = "sha256-AjIs8cY+KUXgBAzZ8ckj0rJjqzCQKYrdF20aQAF76Cg=";
      #   };

      #   monado = oldAttrs.monado.overrideAttrs (prev: {
      #     src = prev.src.override {
      #       rev = "598080453545c6bf313829e5780ffb7dde9b79dc";
      #       hash = "sha256-9LsKvIXAQpr+rpv8gDr4YfoNN+MSkXfccbIwLrWcIXg=";
      #     };
      #   });
      # })).override { cudaSupport = true; };
      openFirewall = true;
      highPriority = true;
      defaultRuntime = true;
      monadoEnvironment = {
        XRT_COMPOSITOR_LOG = "debug";
        XRT_PRINT_OPTIONS = "on";
        IPC_EXIT_ON_DISCONNECT = "on";
      };
    };

    hardware.opengl.extraPackages = [
      inputs.lemonake.packages.${pkgs.system}.monado-vulkan-layers
    ];

    environment.systemPackages = [ pkgs.xrgears ];
  };
}
