{ ... }:

{
  ## NETWORK
  # Set interface name
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="02:00:00:00:00:01", NAME="ether0"
  '';
}
