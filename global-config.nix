{ pkgs, username, fullname, inputs, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      cores = 4;
      keep-outputs = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 5d";
    };
  };

  # Kernel
  security.protectKernelImage = true;
  hardware.enableRedistributableFirmware = true;

  boot.loader.systemd-boot.configurationLimit = 10;

  # Enable networking
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  programs.ssh.enableAskPassword = true;

  ## Time & locale
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

  ## USERS
  users.users.${username} = {
    isNormalUser = true;
    description = "${fullname}";
    extraGroups = [ "wheel" "networkmanager" ];
  };

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
    fastfetch
  ] ++ [ inputs.agenix.packages.${system}.default ];

  kostek001.misc.doas.enable = true;
  kostek001.programs.shell-utils.enable = true;

  programs.bash.shellInit = "HISTCONTROL=ignoreboth";
  environment.shellAliases = {
    nix-update = "sudo nixos-rebuild switch";
    nix-clean = "sudo nix-collect-garbage -d";
  };

  # Doesnt work with flakes
  programs.command-not-found.enable = false;
}
