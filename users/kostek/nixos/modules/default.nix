{ username }: { ... }:

{
  imports = [
    (import ./autologin.nix { inherit username; })
    ./pentesting.nix
    ./vr.nix
  ];
}
