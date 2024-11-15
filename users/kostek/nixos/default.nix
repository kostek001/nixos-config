{ username }: { ... }:

{
  imports = [
    ./config
    (import ./modules { inherit username; })
  ];
}
