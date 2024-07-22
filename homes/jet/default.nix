{
  pkgs,
  lib,
  ...
}: {
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
        } else finalAttrs.src;

        meta = with lib; {
          description = "Rust-based terminal";
          homepage = "https://www.warp.dev";
          license = licenses.unfree;
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          maintainers = with maintainers; [ emilytrau imadnyc donteatoreo johnrtitor ];
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
