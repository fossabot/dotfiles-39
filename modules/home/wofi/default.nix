{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.wofi.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.wofi.enable {
    programs.wofi = {
      enable = true;
      settings = {
        mode = "drun";
        prompt = "";
        allow_images = "false";
        insensitive = "true";
        no_actions = "true";
        hide_scroll = "true";
        allow_markup = "false";
        matching = "multi-contains";
        dynamic_lines = "true";
      };
      style = ''
        * {
          all: unset;
          font-family: "FiraCode Nerd Font";
          font-size: 14px;
        }

        #window {
          background-color: #000000;
          border-radius: 5px;
        }

        #input{
          margin: 8px;
          padding: 0.5rem;
          border-radius: 5px;
          background-color: #262626;
        }

        #entry {
          padding: 8px;
          color: #9699b7;
          border-radius: 5px;
        }

        #entry:selected {
          background-color: #ffffff;
          color: #000000;
        }

        #input:first-child > :nth-child(1) {
          min-height: 0em;
          min-width: 0em;
          background-image: none;
        }
      '';
    };
  };
}
