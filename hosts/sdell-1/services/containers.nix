{ ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "daily";
    flags = [ "--all" "--filter=until=168h" ];
  };
  knix.privileged.groups = [ "docker" ];

  environment.persistence."/nix/persist".directories = [
    "/var/lib/docker/"
    "/etc/pelican/"
    "/var/lib/pelican/"
  ];

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.pelican_wings = {
    image = "ghcr.io/pelican-dev/wings:latest";
    ports = [ "8519:8519" "8520:8520" ];
    environment = {
      WINGS_UID = "1000";
      WINGS_GID = "1000";
      WINGS_USERNAME = "wings";
    };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "/var/lib/docker/containers/:/var/lib/docker/containers/"
      "/etc/pelican/:/etc/pelican/"
      "/var/lib/pelican/:/var/lib/pelican/"
      "/var/log/pelican/:/var/log/pelican/"
      "/tmp/pelican/:/tmp/pelican/"
    ];
  };
}
