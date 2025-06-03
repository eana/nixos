{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.module.swaylock;
  swaylockPkg = import ./package.nix { inherit lib pkgs; };

  defaultSettings = {
    ignore-empty-password = true;
    clock = true;
    timestr = "%H.%M.%S";
    datestr = "%A, %m %Y";
    image = "~/.config/swaylock/lockscreen.jpg";
    inside-color = "#00000000";
    ring-color = "#00000000";
    indicator-thickness = 4;
    line-uses-ring = true;
  };

in
{
  options.module.swaylock = {
    enable = mkEnableOption "swaylock screen locker";

    package = mkOption {
      type = types.package;
      default = swaylockPkg;
      description = "Customized swaylock package";
    };

    settings = mkOption {
      type = types.attrs;
      default = defaultSettings;
      description = "Configuration settings for swaylock";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      inherit (cfg) package;
      inherit (cfg) settings;
    };
  };
}
