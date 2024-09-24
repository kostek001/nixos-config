{ configType }:

{
  imports = [
    ((import ./minimalDesktop).nixos { inherit configType; })
    ((import ./normalDesktop).nixos { inherit configType; })
    ((import ./fullDesktop).nixos { inherit configType; })
    ((import ./pentesting).nixos { inherit configType; })
  ];
}
