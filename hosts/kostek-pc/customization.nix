{ username, ... }:

{
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };
}
