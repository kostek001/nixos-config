rec {
  keys."kostek@kostek-pc" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUS8H2nC59yCrQ7RYIOXolOa0KbSFnuBIehDVaRmVHq kostek@kostek-pc";
  keys."kostek@dellome" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOcXWhr2G4lVo1rfe45hfwcka9OelTroFc+1FJJNA9M kostek@dellome";
  keys."kostek@kostek-pixel" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJz91GKHOpFDZ1CYgBcPv2eGDCxvBl1zGJlkE3zk7h31 kostek@kostek-pixel";
  masterKeys = [ keys."kostek@kostek-pc" ];
}
