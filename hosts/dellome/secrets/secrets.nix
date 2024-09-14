let
  dellome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmRv+uU7rH8rwt7CKvB9q9xf05eFwZZhadEB+utnmpl";
in
{
  "userHashedPassword.age".publicKeys = [ dellome ];
}
