{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.waybar.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.waybar.enable {
    wayland.windowManager.sway.config.bars = [
      {
        command = "${pkgs.waybar}/bin/waybar";
      }
    ];

    # Config
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          height = 28;
          margin = "0 0 0 0";
          modules-left = ["clock" "sway/workspaces"];
          modules-center = [];
          modules-right = ["network" "pulseaudio" "backlight" "battery"];

          # Pulseaudio
          pulseaudio = {
            format = "{icon} {volume}%";
            tooltip = false;
            format-muted = "  MUTED";
            format-icons = {
              default = [" " " " " "];
            };
          };

          # Clock
          clock = {
            format-alt = "{:%Y/%m/%d | %H:%M:%S}";
          };

          # Battery
          battery = {
            format = "{icon} {capacity}%";
            tooltip = false;
            format-icons = [" " " " " " " " " "];
            format-charging = "󱐋 {capacity}%";
            interval = 5;
          };

          # Workspaces
          "sway/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "0" = "10";
            };
            sort-by-number = true;
          };

          # Backlight
          backlight = {
            device = "apple-panel-bl";
            format = "{icon} {percent}%";
            tooltip = false;
            format-icons = ["󰃞 " "󰃟 " "󰃠 "];
          };

          # Network
          network = {
            tooltip = false;
            format-wifi = "  {ipaddr}"; # 󱐋 {frequency}
            format-disconnected = " ";
            format-ethernet = "  {ipaddr}";
            interval = 5;
          };
        }
      ];

      style = ''
        * {
          font-family: Agave, FiraCode Mono Nerd Font;
          font-size: 11px;
          background-color: transparent;
          margin-left: 4px;
          margin-right: 4px;
        }

        window#waybar {
          background-color: #000;
        }

        tooltip {
          background: rgba(0, 0, 0, 1);
          border: 1px solid rgba(255, 255, 255, 1);
        }
        tooltip label {
          color: white;
        }

        #memory,
        #custom-power,
        #battery,
        #backlight,
        #pulseaudio,
        #network,
        #clock,
        #cpu,
        #memory,
        #temperature,
        #disk,
        #mpris,
        #tray {
          border-radius: 2px;
          padding: 2px 4px;
          margin-top: 4px;
          margin-bottom: 4px;
          color: #ffffff;
        }

        #workspaces button {
          all: initial; /* Remove GTK theme values (waybar #1351) */
          min-width: 0; /* Fix weird spacing in materia (waybar #450) */
          padding: 4px 4px;
          border-radius: 6px;
          color: #606060;
        }
        #workspaces button.visible {
          color: #ffffff;
        }

        #pulseaudio-slider {
          all: unset;
        }
        #pulseaudio-slider slider {
          min-height: 0px;
          min-width: 0px;
          padding: 0;
          margin: 0;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
          border-color: transparent;
        }
        #pulseaudio-slider trough {
          min-width: 50px;
          min-height: 10px;
          border-radius: 2px;
          padding: 0;
          margin: 0;
          border-color: #606060;
        }
        #pulseaudio-slider highlight {
          border-radius: 1px;
          background-color: #FFFFFF;
          padding: 0;
          margin: 0;
          border: none;
          outline: none;
          box-shadow: none;
          text-decoration: none;
        }

        /* EDGE MARGINS */
        #clock {
          margin-left: 10px;
          margin-right: 4px;
          background-color: #fff;
          color: #000;
        }
        #battery {
          margin-right: 10px;
        }
      '';
    };
  };
}
