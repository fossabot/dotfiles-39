{
  lib,
  config,
  ...
}: let
  domain = "qazer.org";
  mkRP =
    sub: port:
    let
      dom = if sub == "" then domain else "${sub}.${domain}";
    in {
      "${dom}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${port}";
        };
      };
    };
in {

  options.modules.server.nginx.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.server.nginx.enable {
    services.nginx = {
      enable = true;
      #recommendedZstdSettings = true;
      #recommendedTlsSettings = true;
      #recommendedProxySettings = true;
      #recommendedOptimisation = true;
      /*virtualHosts = lib.mkMerge [
        (mkRP "grafana" "3000")
        (mkRP "pihole" "3001")
        (mkRP "portainer" "8000")
        (mkRP "prometheus" "9090")
        (mkRP "node-exporter" "9100")
        (mkRP "cockpit" (builtins.toString config.services.cockpit.port))
        (mkRP "dashboard" (builtins.toString config.services.homepage-dashboard.listenPort))
      ];*/

      virtualHosts = {
        "grafana.qazer.org" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
      };
    };
  };
}
