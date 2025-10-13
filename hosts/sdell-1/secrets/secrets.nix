let
  self = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwJAoMkSf5gkmlWaao5El9khCnkrK9sKVafbOe73jXi";
  keys = [ self ] ++ (import ../../identities.nix).masterKeys;
in
{
  "userHashedPassword.age".publicKeys = keys;

  # OTELCOL
  "otelcol_otlpAuth.age".publicKeys = keys;
  "otelcol_caCert.age".publicKeys = keys;

  # Restic server
  "resticServer_htpasswd.age".publicKeys = keys;
  "resticServer_tlsCert.age".publicKeys = keys;
  "resticServer_tlsKey.age".publicKeys = keys;
}
