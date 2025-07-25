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
      extraServerFlags = [ "--no-manage-active-runtime" "--no-publish-service" ];
    };

    # Fix REALTIME priority
    security.wrappers."wivrn-server" = {
      setuid = false;
      owner = "root";
      group = "root";
      capabilities = "cap_sys_nice+eip";
      source = getExe config.services.wivrn.package;
    };
    systemd.user.services.wivrn = {
      serviceConfig = mkForce { ExecStart = builtins.concatStringsSep " " ([ "${config.security.wrapperDir}/wivrn-server" "--systemd" ] ++ config.services.wivrn.extraServerFlags); };
    };
  };
}
