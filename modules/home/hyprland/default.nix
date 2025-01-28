{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.hyprland.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.hyprland.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";
        splash = false;
        preload = [
          "/home/alex/.config/wallpaper/wallpaper.png"
        ];
        wallpaper = [
          "HDMI-A-1,/home/alex/.config/wallpaper/wallpaper.png"
          "eDP-1,/home/alex/.config/wallpaper/wallpaper.png"
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      plugins = [ pkgs.hyprlandPlugins.hyprscroller ];

      settings = {
        monitor = [ ",highrr,auto,2" ];
        
        general = {
          # Hyprscroller
          layout = "scroller";
          
          gaps_in = 3;
          gaps_out = 6;
          border_size = 1;
          resize_on_border = true;
          allow_tearing = false;
        };

				plugin = {
					scroller = {
						column_default_width = "seveneighths";
						center_row_if_space_available = true;

					};
				};

        decoration = {
          rounding = 6;
          active_opacity = 0.92;
          inactive_opacity = 0.92;
          blur = {
            enabled = true;
            ignore_opacity = true;
            size = 5;
            passes = 5;
            vibrancy = 0.4;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.87, 0, 0.13, 1";
          animation = [
            "windows, 1, 4, myBezier"
            "windowsOut, 1, 4, myBezier"
            "border, 1, 4, myBezier"
            "borderangle, 1, 4, myBezier"
            "fade, 1, 4, myBezier"
            "workspaces, 0, 4, myBezier"
          ];
        };

        input = {
          kb_layout = "gb";
          kb_variant = "colemak";
          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
            middle_button_emulation = true;
            disable_while_typing = true;
          };
        };

        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
        };

        bind = [
          # Basic controls
          "SUPER, Return, exec, foot"
          "SUPER, E, exec, wofi --show drun"
          "SUPER, Q, killactive"
          "SUPER, SPACE, togglefloating"

          # Window movement
          "SUPER, left, movewindow, l"
          "SUPER, right, movewindow, r"
          "SUPER, up, movewindow, u"
          "SUPER, down, movewindow, d"

          # Workspaces
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          "SUPER, 0, workspace, 10"

					# Workspace Gestures


          # Window to workspace
          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, movetoworkspace, 9"
          "SUPER SHIFT, 0, movetoworkspace, 10"

          # Media controls
          ",XF86AudioRaiseVolume, exec, pamixer -i 5"
          ",XF86AudioLowerVolume, exec, pamixer -d 5"
          ",XF86AudioMute, exec, pamixer -t"
          ",XF86AudioMicMute, exec, pamixer --default-source -t"

          # Brightness controls
          ",XF86MonBrightnessUp, exec, brightnessctl set 1%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 1%-"

          # Keyboard backlight
          "SUPER, XF86MonBrightnessUp, exec, brightnessctl --class leds --device kbd_backlight set 10%+"
          "SUPER, XF86MonBrightnessDown, exec, brightnessctl --class leds --device kbd_backlight set 10%-"
        ];

        exec-once = [
          "waybar"
          "${pkgs.hyprsunset}/bin/hyprsunset -t 3000"
        ];
      };

      extraConfig = ''
        # Add extra config here...
      '';
    };
  };
}
