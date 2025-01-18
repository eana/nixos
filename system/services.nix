{ pkgs }:

{
  pipewire = {
    enable = true;
    pulse.enable = true;
  };

  avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  blueman.enable = true;

  displayManager = { defaultSession = "sway"; };

  xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        settings = { greeter = { IncludeAll = true; }; };
      };
    };
    desktopManager.gnome.enable = true;
    videoDrivers = [ "nvidia" ];
  };

  printing = {
    enable = true;
    drivers = [ pkgs.canon-cups-ufr2 ];
  };

  libinput.enable = true;
  dbus.enable = true;
  openssh.enable = true;

  logind.lidSwitchExternalPower = "ignore";

  ollama = {
    enable = true;
    acceleration = "cuda";
    host = "0.0.0.0";
    port = 11434;
  };

  open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 11343;
  };
}

