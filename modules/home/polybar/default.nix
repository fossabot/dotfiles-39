{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  options.modules.polybar.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.polybar.enable {
    home.packages = with self.packages; [polybarFull];

    xdg.configFile."polybar/config.ini".text = builtins.readFile ./config/default;

    xdg.configFile."polybar/launch.sh".text = builtins.readFile ./config/launch.sh;
    xdg.configFile."polybar/launch.sh".executable = true;
  };
}
