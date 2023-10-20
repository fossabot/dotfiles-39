{...}: {
  imports = [
    ../../modules
  ];

  homeModules = {
    direnv.enable = true;
    git.enable = true;
    neovim.enable = true;
    firefox.enable = true;
    spicetify.enable = true;
    obs.enable = true;
    spotifyd.enable = true;
    obsidian.enable = true;
    
    vscode = {
      enable = true;
      host = "jade";
    };

    waybar = {
      enable = true;
      host = "jade";
    };

    foot = {
      enable = true;
      host = "jade";
    };

    vlc = {
      enable = true;
    };
  };
}
