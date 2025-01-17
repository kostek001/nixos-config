{ lib, pkgs, ... }:

{
  ## BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.timeout = 0;

  # Hibernation
  security.protectKernelImage = lib.mkForce false;
  boot.resumeDevice = "/dev/mapper/nixos";
  boot.kernelParams = [ "nosgx" ] ++ [ "resume_offset=533760" ];

  ## IMPERMANENCE
  fileSystems."/persistence".neededForBoot = true;
  environment.persistence."/persistence" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      # SSH
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # Fix Agenix decryption when using Impermanence [+5 hours wasted on this]
  services.openssh.hostKeys = let path = "/persistence/etc/ssh"; in [
    { path = "${path}/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
    { path = "${path}/ssh_host_ed25519_key"; type = "ed25519"; }
  ];

  # /tmp on Tmpfs
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "12G";
  };

  ## KEYBOARD
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svn*:pn*:pvr*
      KEYBOARD_KEY_d4=leftmeta
      KEYBOARD_KEY_db=capslock
      KEYBOARD_KEY_d5=zoom
      KEYBOARD_KEY_d6=scale
  '';
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [ "0001:0001" ];
      settings = {
        main = {
          back = "back";
          refresh = "refresh";
          zoom = "zoom";
          scale = "cyclewindows";
          print = "print";
          camera = "brightnessdown";
          prog1 = "brightnessup";
          mute = "mute";
          volumedown = "volumedown";
          volumeup = "volumeup";
          sleep = "coffee";
        };
        meta = {
          back = "f1";
          refresh = "f2";
          zoom = "f3";
          scale = "f4";
          camera = "f5";
          prog1 = "f6";
          mute = "f7";
          volumedown = "f8";
          volumeup = "f9";
          switchvideomode = "f12";
        };
        alt = {
          scale = "A-f4";
          camera = "kbdillumdown";
          prog1 = "kbdillumup";
        };
      };
    };
  };

  ## GRAPHICS
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  ## TOUCHSCREEN
  # Disable touchscreen
  boot.extraModprobeConfig = ''
    blacklist melfas_mip4
  '';
}
