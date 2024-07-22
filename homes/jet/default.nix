{ pkgs, lib, ... }: let
  warp-terminal = pkgs.warp-terminal.overrideAttrs (finalAttrs: rec {
    src = pkgs.fetchurl {
      url = "https://releases.warp.dev/stable/v${finalAttrs.version}/warp-terminal-v${finalAttrs.version}-1-aarch64.pkg.tar.zst";
      hash = "sha256-693dSiF82aqTElap/7tZvYd7PQpQBqUvZAsTci2azCo=";
    };

    postInstall = ''
      wrapProgram "$out/bin/warp-terminal" \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath [pkgs.wayland] }
    '';

    meta = with lib; {
      inherit (finalAttrs.meta) description homepage license sourceProvenance maintainers;
      platforms = finalAttrs.meta.platforms ++ [ "aarch64-linux" ];
    };
  });
in {
  imports = [
    ../../modules/home
  ];
  home.packages = with pkgs; [
    obsidian
    nautilus
    gammastep
    fragments
    vesktop
    warp-terminal
  ];

  modules = {
    # Environment
    sway.enable = true;
    waybar.enable = true;
    foot.enable = true;
    mako.enable = true;
    wofi.enable = true;
    dark.enable = true;
    firefox.enable = true;
    fish.enable = true;

    # CLI Tools
    bat.enable = true;
    eza.enable = true;

    # Development
    vscode.enable = true;
    git.enable = true;
    direnv.enable = true;
    #starship.enable = true;
  };

  home.stateVersion = "24.11";
  home.homeDirectory = "/home/alex";

  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.age.sshKeyPaths = ["/home/alex/.ssh/id_ed25519"];
}
