

{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {

  options.homeModules.waybar.ruby.enable = lib.mkEnableOption "";

  config = lib.mkIf config.homeModules.waybar.ruby.enable {
    programs.waybar = {
      enable = true;
      settings = [{
        height = 15;
        layer = "top";
        modules-left = ["sway/workspaces"];
        modules-center = [];
        modules-right = ["network" "pulseaudio" "temperature" "cpu" "memory" "clock"];
        pulseaudio = {
          tooltip = false;
          scroll-step =  5;
          format = "{icon} {volume}%";
          format-icons = {
            default = ["奄", "奔", "墳"];
          };
        };
        network = {
          tooltip = false;
          format-wifi = " {essid} {ipaddr}";
          format-ethernet = " {ipaddr}";
        };
        cpu = {
          tooltip = false;
          format = " {}%";
        };
        memory = {
          tooltip = false;
          format = " {}%";
        };
      }];
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: FiraCode Nerd Font;
          font-size: 14px;
          min-height: 24px;
        }

        window#waybar {
          background: transparent;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        #window {
          margin-top: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 26px;
          transition: none;
          /*
            color: #f8f8f2;
          background: #282a36;
            */
            color: transparent;
          background: transparent;
        }

        window#waybar.termite #window,
        window#waybar.Firefox #window,
        window#waybar.Navigator #window,
        window#waybar.PCSX2 #window {
            color: #4d4d4d;
          background: #e6e6e6;
        }

        #workspaces {
          margin-top: 8px;
          margin-left: 12px;
          margin-bottom: 0;
          border-radius: 26px;
          background: #282a36;
          transition: none;
        }

        #workspaces button {
          transition: none;
          color: #f8f8f2;
          background: transparent;
          font-size: 16px;
        }

        #workspaces button.focused {
          color: #9aedfe;
        }

        #workspaces button:hover {
          transition: none;
          box-shadow: inherit;
          text-shadow: inherit;
          color: #ff79c6;
        }

        #mpd {
          margin-top: 8px;
          margin-left: 8px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          background: #282a36;
          transition: none;
          color: #4d4d4d;
          background: #5af78e;
        }

        #mpd.disconnected,
        #mpd.stopped {
          color: #f8f8f2;
          background: #282a36;
        }

        #network {
          margin-top: 8px;
          margin-left: 8px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          transition: none;
          color: #4d4d4d;
          background: #bd93f9;
        }

        #pulseaudio {
          margin-top: 8px;
          margin-left: 8px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          transition: none;
          color: #4d4d4d;
          background: #9aedfe;
        }

        #temperature {
          margin-top: 8px;
          margin-left: 8px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          transition: none;
          color: #4d4d4d;
          background: #5af78e;
        }

        #cpu {
          margin-top: 8px;
          margin-left: 8px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          transition: none;
          color: #4d4d4d;
          background: #f1fa8c;
        }

        #memory {
          margin-top: 8px;
          margin-left: 8px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          transition: none;
          color: #4d4d4d;
          background: #ff6e67;
        }

        #clock {
          margin-top: 8px;
          margin-left: 8px;
          margin-right: 12px;
          padding-left: 16px;
          padding-right: 16px;
          margin-bottom: 0;
          border-radius: 26px;
          transition: none;
          color: #f8f8f2;
          background: #282a36;
        }
      '';
    };
  };
}