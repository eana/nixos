{ config, pkgs, ... }:
let
  # Do not change this value! This tracks when NixOS was installed on your system.
  stateVersion = "24.05";
  hostName = "nixbox";
in {
  imports = [ ./hardware-configuration.nix ./disko.nix ./gdm.nix ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    enableAllFirmware = true;
    graphics.enable = true;
    nvidia = {
      prime = {
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
      modesetting.enable = false;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # I spotted this in the logs:
    # Jan 15 16:48:17 nixbox kernel: snd_soc_avs 0000:00:1f.3: Direct firmware load for intel/avs/hda-10ec0298-tplg.bin failed with error -2
    # Jan 15 16:48:17 nixbox kernel: snd_soc_avs 0000:00:1f.3: request topology "intel/avs/hda-10ec0298-tplg.bin" failed: -2
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.0: trying to load fallback topology hda-generic-tplg.bin
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.0: ASoC: Parent card not yet available, widget card binding deferred
    # Jan 15 16:48:17 nixbox kernel: input: hdaudioB0D0 Headphone Mic as /devices/platform/avs_hdaudio.0/sound/card0/input21
    # Jan 15 16:48:17 nixbox kernel: snd_hda_codec_hdmi hdaudioB0D2: creating for HDMI 0 0
    # Jan 15 16:48:17 nixbox kernel: snd_hda_codec_hdmi hdaudioB0D2: skipping capture dai for HDMI 0
    # Jan 15 16:48:17 nixbox kernel: snd_hda_codec_hdmi hdaudioB0D2: creating for HDMI 1 1
    # Jan 15 16:48:17 nixbox kernel: snd_hda_codec_hdmi hdaudioB0D2: skipping capture dai for HDMI 1
    # Jan 15 16:48:17 nixbox kernel: snd_hda_codec_hdmi hdaudioB0D2: creating for HDMI 2 2
    # Jan 15 16:48:17 nixbox kernel: snd_hda_codec_hdmi hdaudioB0D2: skipping capture dai for HDMI 2
    # Jan 15 16:48:17 nixbox kernel: snd_soc_avs 0000:00:1f.3: Direct firmware load for intel/avs/hda-80862809-tplg.bin failed with error -2
    # Jan 15 16:48:17 nixbox kernel: snd_soc_avs 0000:00:1f.3: request topology "intel/avs/hda-80862809-tplg.bin" failed: -2
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.2: trying to load fallback topology hda-8086-generic-tplg.bin
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.2: ASoC: Parent card not yet available, widget card binding deferred
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.2: avs_card_late_probe: mapping HDMI converter 1 to PCM 1 (0000000044de3967)
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.2: avs_card_late_probe: mapping HDMI converter 2 to PCM 2 (000000007a87bd93)
    # Jan 15 16:48:17 nixbox kernel: avs_hdaudio avs_hdaudio.2: avs_card_late_probe: mapping HDMI converter 3 to PCM 3 (00000000c5ee6c25)
    # Jan 15 16:48:17 nixbox kernel: input: hdaudioB0D2 HDMI/DP,pcm=1 as /devices/platform/avs_hdaudio.2/sound/card1/input22
    # Jan 15 16:48:17 nixbox kernel: input: hdaudioB0D2 HDMI/DP,pcm=2 as /devices/platform/avs_hdaudio.2/sound/card1/input23
    # Jan 15 16:48:17 nixbox kernel: input: hdaudioB0D2 HDMI/DP,pcm=3 as /devices/platform/avs_hdaudio.2/sound/card1/input24
    # The sound refused to work until I blacklisted snd_soc_avs
    # https://discourse.nixos.org/t/no-microphone-how-to-get-firmware-dsp-basefw-bin/38198/9
    blacklistedKernelModules = [ "snd_soc_avs" ];

    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  time.timeZone = "Europe/Stockholm";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = null;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services = {
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

    printing.enable = true;
    printing.drivers = [ pkgs.canon-cups-ufr2 ];
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
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome_5
      meslo-lgs-nf
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.space-mono
      powerline-fonts
      powerline-symbols
      source-code-pro
    ];
  };

  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  # Use zsh as your default shell.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.sway.enable = true;
  programs.ssh.startAgent = true;

  environment = {
    systemPackages = with pkgs; [
      # Browsers
      firefox # A free and open-source web browser developed by Mozilla
      google-chrome # A fast, secure, and free web browser built for the modern web by Google

      # Terminal Emulators
      foot # A fast, lightweight and minimalistic Wayland terminal emulator

      # Utilities
      blueman # A GTK+ Bluetooth manager
      curl # A command-line tool for transferring data with URLs
      dive # A tool for exploring a Docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image
      docker-compose # A tool for defining and running multi-container Docker applications
      gparted # A free partition editor for graphically managing disk partitions
      podman-tui # A terminal user interface for managing Podman containers

      # IDEs
      jetbrains.idea-community-bin # The free and open-source edition of IntelliJ IDEA, an IDE for Java development
      vscode # Visual Studio Code, a source-code editor developed by Microsoft

      # Shells
      zsh-powerlevel10k # A theme for Zsh that emphasizes speed, flexibility, and out-of-the-box experience
    ];
    variables = {
      EDITOR = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = config.hardware.graphics.extraPackages;
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      autoPrune.enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = stateVersion;
}
