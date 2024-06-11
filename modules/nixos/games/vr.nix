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
      # package = inputs.lemonake.packages.${pkgs.system}.wivrn.override { cudaSupport = true; };
      package = (inputs.lemonake.packages.${pkgs.system}.wivrn.overrideAttrs (oldAttrs: rec {
        version = "9cd67a1f72544454531195a893eb07f2217fdfe5";
        src = oldAttrs.src.override {
          rev = version;
          hash = "sha256-EmXsZmXYBhdo6aqm7NeOOFWsXASzzE3YaPMiEScA2Po=";
        };

        monado = oldAttrs.monado.overrideAttrs (prev: {
          src = prev.src.override {
            rev = "598080453545c6bf313829e5780ffb7dde9b79dc";
            hash = "sha256-9LsKvIXAQpr+rpv8gDr4YfoNN+MSkXfccbIwLrWcIXg=";
          };
        });
      })).override { cudaSupport = true; };
      openFirewall = true;
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

    environment.systemPackages = with pkgs; [ 
      xrgears
      wlx-overlay-s
    ];
  };
}
