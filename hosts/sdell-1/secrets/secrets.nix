let
  self = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwJAoMkSf5gkmlWaao5El9khCnkrK9sKVafbOe73jXi";
  keys = [ self ] ++ (import ../../identities.nix).masterKeys;
in
{
  "userHashedPassword.age".publicKeys = keys;
}
