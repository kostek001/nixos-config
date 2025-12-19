let
  wnet-dell0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKi5CiM0BNHOElgMtf4TjkiQO6QKtoeujN3V4H6A7PHt";
  keys = [ wnet-dell0 ] ++ (import ../../identities.nix).masterKeys;
in
{
  "rootHashedPassword.age".publicKeys = keys;
}
