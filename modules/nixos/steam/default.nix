{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.steam.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.steam.enable {
    programs.steam = {
      enable = true;
      ## Used to translate X11 inputs to uinputs for wayland compat.
      extest.enable = true;
      package = pkgs.steam.override {
        extraPkgs = _pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
            gamemode
            mangohud
            openssl
          ];
      };
    };
  };
}
