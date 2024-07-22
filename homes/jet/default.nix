{pkgs, ...}: {
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

  nixpkgs.overlays = [
    (final: prev: {
      warp-terminal = prev.warp-terminal.overrideAttrs (finalAttrs: rec {
        src = if final.stdenv.isAarch64 then pkgs.fetchurl {
          url = "https://releases.warp.dev/stable/v${finalAttrs.version}/warp-terminal-v${finalAttrs.version}-1-aarch64.pkg.tar.zst";
          # No need to specify sha256; the package will handle it.
        } else finalAttrs.src;

        meta = with lib; {
          inherit (finalAttrs.meta) description homepage license sourceProvenance maintainers;
          platforms = finalAttrs.meta.platforms ++ [ "aarch64-linux" ];
        };
      });
    })
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
