{ pkgs, inputs, ... }:

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

  boot.loader.systemd-boot.configurationLimit = 10;

  security.protectKernelImage = true;

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  services.fstrim.enable = true;
  zramSwap.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  programs.ssh.enableAskPassword = true;

  # TODO: move to automatic timezone, or make machine specific
  time.timeZone = "Europe/Warsaw";

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
    btop
  ] ++ [ inputs.agenix.packages.${system}.default ];

  knix.misc.doas.enable = true;
  knix.programs.shell-utils.enable = true;

  programs.bash.shellInit = "HISTCONTROL=ignoreboth";
  environment.shellAliases = {
    nix-update = "sudo nixos-rebuild switch";
    nix-clean = "sudo nix-collect-garbage -d";
  };

  # Doesnt work with flakes
  programs.command-not-found.enable = false;
}
