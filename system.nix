{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./disko.nix ];

  hardware = {
    bluetooth = {
      enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
    enableAllFirmware = true;
    graphics.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixbox";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Stockholm";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8/UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
    inputMethod.enabled = null;
  };

  services = {
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    xserver.enable = true;
    xserver.displayManager.gdm.enable = true;
    xserver.displayManager.gdm.wayland = true;
    printing.enable = true;
    libinput.enable = true;
    dbus.enable = true;
    openssh.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs;
      [ font-awesome powerline-fonts powerline-symbols ]
      ++ builtins.filter lib.attrsets.isDerivation
      (builtins.attrValues pkgs.nerd-fonts);
  };

  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment = {
    systemPackages = with pkgs; [ sway neovim curl gparted blueman ];
    variables = {
      EDITOR = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
