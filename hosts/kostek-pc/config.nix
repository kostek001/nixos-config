#
# kostek-pc Configuration
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  kostek001.boot.loader.lanzaboote.enable = true;

  kostek001.hardware.nvidia.enable = true;

  powerManagement.cpuFreqGovernor = null;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Enable swap on luks
  boot.initrd.luks.devices."luks-318904c2-e121-4f98-9ea3-591e009f9f63".device = "/dev/disk/by-uuid/318904c2-e121-4f98-9ea3-591e009f9f63";

  # @---- DISKS ----@
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/disk-1" =
    {
      device = "/dev/disk/by-uuid/7A14BB9314BB50BD";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
}
