let
  kostek-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUS8H2nC59yCrQ7RYIOXolOa0KbSFnuBIehDVaRmVHq kostek@kostek-pc";
  dellome = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIw1WCEhVtXmjDfjSFHUN+agyg1mNqi1bYMA5EyxPPqy kostek@dellome";
  trustedHosts = [ kostek-pc dellome ];
in
{
  "kostek/wakatime.cfg.age".publicKeys = trustedHosts;
}
