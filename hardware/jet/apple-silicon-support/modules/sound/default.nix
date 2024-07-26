{
  config,
  options,
  self,
  lib,
  ...
}: {
  imports = [
    # disable pulseaudio as the Asahi sound infrastructure can't use it.
    # if we disable it only if setupAsahiSound is enabled, then infinite
    # recursion results as pulseaudio enables config.sound by default.
    {config.hardware.pulseaudio.enable = !config.hardware.asahi.enable;}
  ];

  options.hardware.asahi = {
    setupAsahiSound = lib.mkOption {
      type = lib.types.bool;
      default = config.sound.enable && config.hardware.asahi.enable;
      description = ''
        Set up the Asahi DSP components so that the speakers and headphone jack
        work properly and safely.
      '';
    };
  };

  config = let
    cfg = config.hardware.asahi;

    inherit (self.packages) asahi-audio; # the asahi-audio we use

    inherit (self.packages) lsp-plugins; # the lsp-plugins we use

    lsp-plugins-is-safe = self.packages.lib.versionAtLeast lsp-plugins.version "1.2.14";
  in
    lib.mkIf (cfg.setupAsahiSound && cfg.enable) (lib.mkMerge [
      {
        # enable pipewire to run real-time and avoid audible glitches
        security.rtkit.enable = true;
        # set up pipewire with the supported capabilities (instead of pulseaudio)
        # and asahi-audio configs and plugins
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;

          configPackages = [asahi-audio];
          extraLv2Packages = [lsp-plugins self.packages.bankstown-lv2];

          wireplumber = {
            enable = true;

            configPackages = [asahi-audio];
            extraLv2Packages = [lsp-plugins self.packages.bankstown-lv2];
          };
        };

        # set up enivronment so that UCM configs are used as well
        environment.variables.ALSA_CONFIG_UCM2 = "${self.packages.alsa-ucm-conf-asahi}/share/alsa/ucm2";
        systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 = config.environment.variables.ALSA_CONFIG_UCM2;
        systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 = config.environment.variables.ALSA_CONFIG_UCM2;

        # enable speakersafetyd to protect speakers
        systemd.packages =
          lib.mkAssert lsp-plugins-is-safe
          "lsp-plugins is unpatched/outdated and speakers cannot be safely enabled"
          [self.packages.speakersafetyd];
        services.udev.packages = [self.packages.speakersafetyd];

        # asahi-sound requires wireplumber 0.5.2 or above
        # https://github.com/AsahiLinux/asahi-audio/commit/29ec1056c18193ffa09a990b1b61ed273e97fee6
        assertions = [
          {
            assertion = lib.versionAtLeast self.packages.wireplumber.version "0.5.2";
            message = "wireplumber >= 0.5.2 is required for sound with nixos-apple-silicon.";
          }
        ];
      }
    ]);
}
