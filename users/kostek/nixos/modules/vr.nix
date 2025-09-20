{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.knix.users.kostek.vr;
in
{
  options.knix.users.kostek.vr = {
    enable = mkEnableOption "VR";
  };

  config = mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      package = pkgs.wivrn.override { ovrCompatSearchPaths = ""; };
      openFirewall = false;
      defaultRuntime = true;
      autoStart = false;
      highPriority = true;
      extraServerFlags = [ "--no-manage-active-runtime" "--no-publish-service" ];
    };
  };
}
