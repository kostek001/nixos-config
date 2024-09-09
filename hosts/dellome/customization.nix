{ pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [ "0001:0001" ];
      settings = {
        main = {
          back = "back";
          refresh = "refresh";
          zoom = "f11";
          scale = "scale";
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
          meta = "capslock";
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
}