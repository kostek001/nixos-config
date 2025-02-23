{ config, lib, ... }:
with lib;

let
  cfg = config.knix.privileged;
in
{
  options.knix.privileged = {
    groups = mkOption {
      type = with types; (listOf str);
      default = [ ];
      description = "List of groups for privileged users";
    };
  };
}
