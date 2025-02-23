let
  dellome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmRv+uU7rH8rwt7CKvB9q9xf05eFwZZhadEB+utnmpl";
  keys = [ dellome ] ++ (import ../../identities.nix).masterKeys;
in
{
  "userHashedPassword.age".publicKeys = keys;
}
