{
  pkgs,
  ...
}:
let
  theme = {
    package = pkgs.yaru-theme;
    name = "Yaru-prussiangreen";
  };

  aws-export-profile = pkgs.stdenv.mkDerivation {
    name = "aws-export-profile";
    src = pkgs.fetchFromGitHub {
      owner = "cytopia";
      repo = "aws-export-profile";
      rev = "a08ed774a36e5a7386adf645652a4af7b972e208"; # specific commit/tag
      sha256 = "sha256-hvQzKXHfeyN4qm6kEAG/xuIqmHhL8GKpvn8aE+gTMDE=";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp aws-export-profile $out/bin/aws-export-profile.sh
      chmod +x $out/bin/aws-export-profile.sh
    '';
  };
in
{
  imports = [ ./common.nix ];

  systemd.user = {
    startServices = "sd-switch";

    services = {
      copyq = {
        Unit = {
          Description = "CopyQ clipboard management daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.copyq}/bin/copyq";
          Restart = "on-failure";
          Environment = [ "QT_QPA_PLATFORM=xcb" ];
        };
        Install.WantedBy = [ "sway-session.target" ];
      };

      telegram = {
        Unit = {
          Description = "Telegram Desktop";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.telegram-desktop}/bin/telegram-desktop -startintray";
          Restart = "on-failure";
          Environment = [ "QT_QPA_PLATFORM=xcb" ];
        };
        Install.WantedBy = [ "sway-session.target" ];
      };

      bluetooth-applet = {
        Unit = {
          Description = "Blueman Applet";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.blueman}/bin/blueman-applet";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "sway-session.target" ];
      };

      swaynag-battery = {
        Unit = {
          Description = "Low battery notification";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.swaynag-battery}/bin/swaynag-battery";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "sway-session.target" ];
      };
    };
  };

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        font-name = "Helvetica Neue LT Std 11";
        monospace-font-name = "Source Code Pro 12";
        document-font-name = "Cantarell 12";
      };
    };
  };

  gtk = {
    enable = true;

    inherit theme;
    iconTheme = theme;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 0;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 0;
  };

  # Install packages for user.
  # Search for packages here: https://search.nixos.org/packages
  home = {
    packages = with pkgs; [
      # SwayWM and Wayland Tools
      wl-clipboard # Clipboard support for Wayland
      libnotify # Desktop notifications
      networkmanagerapplet # Network manager applet
      grim # Screenshot utility for Wayland
      mako # Notification daemon for Wayland
      slurp # Select a region in Wayland
      swaybg # Wallpaper tool for Sway
      swayidle # Idle management daemon for Sway
      imagemagick # Image manipulation tool

      # File Management
      gthumb # Image browser and viewer
      nautilus # File manager

      # Development Tools
      nil # Nix language server
      nix-tree # Visualize Nix dependencies
      meld # Visual diff and merge tool
      gnumake # Build automation tool
      gcc # GNU Compiler Collection
      tree-sitter # Incremental parsing system
      go # Go programming language
      gotools # Tools for Go programming
      nix-prefetch-git # Prefetch Git repositories
      aws-export-profile # AWS profile exporter

      # Language Servers and Linters
      bash-language-server # Language server for Bash
      black # Python code formatter
      jsonnet-language-server # Language server for Jsonnet
      lua-language-server # Language server for Lua
      nodePackages.jsonlint # JSON linter
      nodePackages.prettier # Code formatter
      shellcheck # Shell script analysis tool
      shfmt # Shell script formatter
      stylua # An opinionated code formatter for Lua
      terraform-ls # Language server for Terraform
      tflint # Linter for Terraform
      yaml-language-server # Language server for YAML
      yamlfmt # YAML formatter

      # Containers
      podman # Tool for managing OCI containers

      # Fonts
      cantarell-fonts # Cantarell font family

      # Other
      blueman # Bluetooth manager
      copyq # Clipboard manager
      earlyoom # Early OOM daemon
      brightnessctl # Utility to control brightness
      pavucontrol # PulseAudio volume control
      playerctl # Media player controller
      system-config-printer # Printer configuration tool
      fuse-emulator # ZX Spectrum emulator
      oath-toolkit # OATH one-time password tool
      awscli2 # AWS command-line interface
      aider-chat # AI-powered code review tool

      # Bitwarden
      pinentry-tty # Pinentry for Bitwarden
      rbw # Bitwarden CLI
      rofi # Window switcher, application launcher, and dmenu replacement
      rofi-rbw-wayland # Bitwarden integration for Rofi
    ];

    sessionVariables = {
      LIBGL_ALWAYS_INDIRECT = 1;
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
      KPT_FN_RUNTIME = "podman";
    };
  };

  module = {
    avizo.enable = true;
    foot = {
      enable = true;
      font.size = 10;
    };
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Fira Code:size=12";
          dpi-aware = "no";
        };
      };
    };
    gammastep.enable = true;
    kanshi.enable = true;
    mhalo = {
      enable = true;
      swayKeybinding = "Mod4+Shift+m";
    };
    openra = {
      enable = true;
      release = "release-20250330";
      variants = {
        "red-alert" = {
          enable = true;
          appimageSha256 = "sha256-PLccdCgYjIUm3YkWmT/Bb6F7pfKKNZaKgmfz258hhv4=";
          iconSha256 = "sha256-6IadsH5NGKXZ3gye3JYVTCDC/uPwy3BRXhuAp5+10qA=";
        };
        "dune" = {
          enable = true;
          appimageSha256 = "sha256-dYWYa/DNSI3rrsP634U8GQEAPv+UXbrV3pWwtr14Gmc=";
          iconSha256 = "sha256-vpXer6ZhUWr3RUmNNY8gvxIFMjZRa/E9jGSjNziMysQ=";
        };
        "tiberian-dawn" = {
          enable = true;
          appimageSha256 = "sha256-s9IC0b9wG+WYnEHCVtGb0rF4hpTfAeNDrehlzxGQcGs=";
          iconSha256 = "sha256-vpXer6ZhUWr3RUmNNY8gvxIFMjZRa/E9jGSjNziMysQ=";
        };
      };
    };
    sway = {
      enable = true;
      background = "~/.local/share/backgrounds/hannah-grace-dSqWwzrLJaQ-unsplash.jpg";
      swaylock.enable = true;
    };
    waybar = {
      enable = true;
      systemdIntegration = false;
    };
  };
}
