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
      openFirewall = false;
      defaultRuntime = true;
      autoStart = false;
      config = {
        enable = true;
        json = {
          application = [ pkgs.wlx-overlay-s ];
          tcp_only = true;
          scale = 0.8;
          bitrate = 150 * 1000000;
        };
      };
    };

    # CAP_SYS_NICE fix
    security.wrappers."wivrn-service" = {
      owner = "root";
      group = "root";
      # cap_sys_nice needed for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = getExe config.services.wivrn.package;
    };

    systemd.user.services.wivrn.serviceConfig = mkForce (
      let
        cfg = config.services.wivrn;
        configFormat = pkgs.formats.json { };

        # For the application option to work with systemd PATH, we find the store binary path of
        # the package, concat all of the following strings, and then update the application attribute.
        # Application can either be a package or a list that has a package as the first element.
        applicationExists = builtins.hasAttr "application" cfg.config.json;
        applicationListNotEmpty = (
          if builtins.isList cfg.config.json.application then
            (builtins.length cfg.config.json.application) != 0
          else
            true
        );
        applicationCheck = applicationExists && applicationListNotEmpty;

        applicationBinary = (
          if builtins.isList cfg.config.json.application then
            builtins.head cfg.config.json.application
          else
            cfg.config.json.application
        );
        applicationStrings = builtins.tail cfg.config.json.application;

        applicationPath = mkIf applicationCheck applicationBinary;

        applicationConcat = (
          if builtins.isList cfg.config.json.application then
            builtins.concatStringsSep " " ([ (getExe applicationBinary) ] ++ applicationStrings)
          else
            (getExe applicationBinary)
        );
        applicationUpdate = recursiveUpdate cfg.config.json (
          optionalAttrs applicationCheck { application = applicationConcat; }
        );
        configFile = configFormat.generate "config.json" applicationUpdate;
      in
      {
        ExecStart = "${config.security.wrapperDir}/wivrn-service --systemd -f ${configFile}";
      }
    );

    hardware.graphics.extraPackages = [
      inputs.lemonake.packages.${pkgs.system}.monado-vulkan-layers
    ];

    # SlimeVR
    environment.systemPackages = [ inputs.kostek001-pkgs.packages.${pkgs.system}.slimevr ];
    networking.firewall.allowedTCPPorts = [ 21110 ];
    networking.firewall.allowedUDPPorts = [ 35903 6969 ];
  };
}
