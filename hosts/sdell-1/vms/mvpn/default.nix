{ pkgs, ... }:

{
  systemd.network.networks."30-vm-mvpn" = {
    matchConfig.Name = "vm-mvpn";
    address = [
      "10.99.0.10/31"
    ];
    networkConfig = {
      IPMasquerade = "ipv4";
      IPv4Forwarding = true;
    };
  };

  networking.firewall.extraForwardRules = ''
    iifname "vm-mvpn" ip daddr != 192.168.0.0/16 ip daddr != 172.16.0.0/12 ip daddr != 10.0.0.0/8 accept
  '';

  networking.nftables.tables.nixos-nat.content = ''
    chain prerouting {
      type nat hook prerouting priority dstnat; policy accept;
      iifname "vlan20" ip daddr 192.168.20.13 udp dport 21331 dnat to 10.99.0.11
    }
  '';

  # Readonly secrets
  fileSystems."/run/microvms/mvpn/srv/secrets" = {
    device = "/srv/vms/mvpn/secrets";
    options = [ "bind" "ro" ];
  };

  microvm.vms.mvpn = {
    # The package set to use for the microvm. This also determines the microvm's architecture.
    pkgs = pkgs;

    config = {
      # Smaller QEMU package (without cpu emulation)
      microvm.vmHostPackages = pkgs // {
        qemu = pkgs.qemu_kvm;
      };

      microvm.interfaces = [{
        type = "tap";
        id = "vm-mvpn";
        mac = "02:00:00:00:00:01";
      }];

      # Share host's nix-store to prevent building huge images.
      microvm.shares = [
        {
          proto = "virtiofs";
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }
        {
          proto = "virtiofs";
          tag = "secrets";
          source = "/run/microvms/mvpn/srv/secrets";
          mountPoint = "/srv/secrets";
        }
      ];

      microvm.qemu.serialConsole = false;
      microvm.qemu.extraArgs = [
        # "-serial"
        # "chardev:stdio"

        "-chardev"
        "pty,path=/tmp/microvm-mvpn,id=pty0"

        "-serial"
        "chardev:pty0"
      ];
      boot.kernelParams = [
        "earlyprintk=ttyS0"
        "console=ttyS0"
        # "earlyprintk=ttyS1"
        # "console=ttyS1"
      ];

      imports = [ ./config ];
    };
  };

}
