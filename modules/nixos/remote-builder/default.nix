{
  lib,
  config,
  ...
}: {
  options.modules.remote-builder.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.remote-builder.enable {
    services.openssh.enable = true;

    networking.firewall.allowedTCPPorts = [
      22 # SSH
    ];

    nix = {
      settings = {
        system-features = [
          "big-parallel"
        ];
        trusted-users = [
          "root"
          "alex"
        ];
        max-jobs = "auto";
        cores = 0;
      };
      buildMachines = [
        {
          inherit (config.networking) hostName;
          protocol = "ssh-ng";
          systems = ["x86_64-linux" "aarch64-linux"];
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
        }
      ];
      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };

    # enable binfmt to compile aarch64 code
    boot.binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };
}
