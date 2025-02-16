let
  dellete = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB94R/srdRPOH3Glw/VysDlX9ark3dlK9HA3Ziu4L2Ax";
  keys = [ dellete ] ++ (import ../../identities.nix).globalKeys;
in
{
  "rootHashedPassword.age".publicKeys = keys;
  "robolHashedPassword.age".publicKeys = keys;
  "olekHashedPassword.age".publicKeys = keys;
}
