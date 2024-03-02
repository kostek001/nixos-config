{ config, pkgs, username, fullname, hostname, ... }:

{
  system.stateVersion = "23.11";

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 5d";
    };
  };

  security.protectKernelImage = true;

  # Fix booting from USB to SATA adapter
  boot.kernelParams = [ "quiet" "nosgx" ] ++ [
    "usb-storage.quirks=152d:0583:u"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.hostName = hostname;

  # @---- TIME & LOCALE ----@

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "pl_PL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };


  # @---- DESKTOP ENVIRONMENT ----@

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  environment.shellAliases = {
    nix-update = "sudo nixos-rebuild switch";
    nix-clean = "sudo nix-collect-garbage -d";
  };

  ## USERS
  users.users.${username} = {
    isNormalUser = true;
    description = "${fullname}";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  kostek001.misc.doas.enable = true;

  ## SYSTEM PACKAGES
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #### Core Packages
    lz4
    wget
    git
    pciutils
    usbutils
    file
    neofetch
    # Build essentials
    # gnumake
    # gcc
    # gdb
    # ncurses
  ];

  kostek001.programs.shell-utils.enable = true;
}
