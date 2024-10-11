{ pkgs, username, ... }:

{
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svn*:pn*:pvr*
      KEYBOARD_KEY_d4=leftmeta
      KEYBOARD_KEY_db=capslock
      KEYBOARD_KEY_d5=zoom
      KEYBOARD_KEY_d6=scale
  '';

  boot.extraModprobeConfig = ''
    blacklist melfas_mip4
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
