{pkgs, ...}: {
  imports = [
    ../../modules/home
  ];

  home.packages = with pkgs; [
    obsidian
    gnome.nautilus
    gammastep
    fragments
    obs-studio
  ];

  modules = {
    # Environment
    sway.enable = true;
    waybar.enable = true;
    foot.enable = true;
    git.enable = true;
    dark.enable = true;
    mako.enable = true;
    wofi.enable = true;
    firefox.enable = true;
    eza.enable = true;
    starship.enable = true;

    # Development
    vscode.enable = true;
  };

  home.stateVersion = "23.05";
  home.homeDirectory = "/home/alex";

  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.age.sshKeyPaths = ["/home/alex/.ssh/id_ed25519"];
}
