{ lib, pkgs, inputs, ... }:

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
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
  };

  boot.loader.systemd-boot.configurationLimit = 10;

  security.protectKernelImage = true;

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # Enable FSTRIM (for SSDs) and ZRAM
  services.fstrim.enable = true;
  zramSwap.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      UseDns = false;
    };
    # Only allow system-level authorized_keys to avoid injections.
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
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

  ## From nix-community/srvos
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
}
