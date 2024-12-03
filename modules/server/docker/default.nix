{
  lib,
  config,
  ...
}: {
  options.modules.server.docker.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.server.docker.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        data-root = "/var/lib/docker";
        "hosts" = [ "tcp://0.0.0.0:2376" "unix:///var/run/docker.sock" ];
      };
    };
    users.users.alex.extraGroups = ["docker"];
    # Allow the SSH daemon to load before docker.
    systemd.services.docker = {
      after = [ "sshd.service" ];
    };
  };
}
