{ configType }:

{
  imports = [
    ((import ./minimalDesktop).home-manager { inherit configType; })
    ((import ./normalDesktop).home-manager { inherit configType; })
    ((import ./fullDesktop).home-manager { inherit configType; })
  ];
}
