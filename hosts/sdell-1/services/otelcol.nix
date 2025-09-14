{ config, pkgs, ... }:

{
  age.secrets."self.otelcol_otlpAuth".file = ../secrets/otelcol_otlpAuth.age;
  age.secrets."self.otelcol_caCert" = {
    file = ../secrets/otelcol_caCert.age;
    mode = "444";
  };

  systemd.services.opentelemetry-collector = {
    serviceConfig.EnvironmentFile = [ config.age.secrets."self.otelcol_otlpAuth".path ];
  };

  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = rec {
      extensions = {
        "basicauth/otlp_client" = {
          client_auth = {
            username = "\${env:OTLP_CLIENT_USERNAME}";
            password = "\${env:OTLP_CLIENT_PASSWORD}";
          };
        };
      };

      receivers = {
        hostmetrics = {
          scrapers = {
            cpu = {
              metrics = {
                "system.cpu.logical.count".enabled = true;
              };
            };
            disk = { };
            load = { };
            filesystem = {
              metrics = {
                "system.filesystem.utilization".enabled = true;
              };
            };
            memory = {
              metrics = {
                "system.memory.utilization".enabled = true;
                "system.memory.limit".enabled = true;
              };
            };
            network = { };
            paging = { };
            processes = { };
            # process = { };
            system = { };
          };
        };
      };

      processors = {
        "resourcedetection/system" = {
          detectors = [ "system" ];
          system = {
            hostname_sources = [ "os" ];
          };
        };
      };

      exporters = {
        otlp = {
          endpoint = "msi-1.20.wnet.internal:4317";
          auth.authenticator = "basicauth/otlp_client";
          tls.ca_file = config.age.secrets."self.otelcol_caCert".path;
        };
      };

      service = {
        extensions = builtins.attrNames extensions;
        pipelines = {
          metrics = {
            receivers = [ "hostmetrics" ];
            processors = [ "resourcedetection/system" ];
            exporters = [ "otlp" ];
          };
          # traces = {
          #   receivers = [ "otlp" ];
          #   processors = [ ];
          #   exporters = [ "otlp" ];
          # };
          # logs = {
          #   receivers = [ "otlp" ];
          #   processors = [ ];
          #   exporters = [ "otlp" ];
          # };
        };
      };
    };
  };
}
