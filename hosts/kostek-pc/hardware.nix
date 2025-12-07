{ config, ... }:

{
  ## BOOT
  knix.boot.loader.lanzaboote.enable = true;

  boot.kernelParams =
    # Hide "SGX disabled by BIOS."
    [ "nosgx" ];

  ## NVIDIA
  knix.hardware.nvidia.enable = true;

  ## DISKS
  # Enable TRIM
  boot.initrd.luks.devices."luks-fbdcf386-6e66-4d69-87cb-9511d65f7fbe".allowDiscards = true;
  boot.initrd.luks.devices."luks-318904c2-e121-4f98-9ea3-591e009f9f63".allowDiscards = true;

  fileSystems."/".options = [ "noatime" ];
  fileSystems."/boot".options = [ "noatime" ];

  # Enable swap on luks
  boot.initrd.luks.devices."luks-318904c2-e121-4f98-9ea3-591e009f9f63".device = "/dev/disk/by-uuid/318904c2-e121-4f98-9ea3-591e009f9f63";

  ## ADDITIONAL DISKS
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/disk-1" = {
    device = "/dev/disk/by-uuid/7A14BB9314BB50BD";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "x-gvfs-show" ];
  };
}
