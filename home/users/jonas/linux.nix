{ pkgs, ... }:
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
          ExecStart = "${pkgs.telegram-desktop}/bin/Telegram -startintray";
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
        font-name = "Helvetica Neue LT Std";
        monospace-font-name = "Source Code Pro";
        document-font-name = "Cantarell";
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
      # File Management
      gthumb # Image browser and viewer

      # Media
      freetube # YouTube client

      # Development Tools
      aws-export-profile # AWS profile exporter
      gcc # GNU Compiler Collection
      gnumake # Build automation tool
      meld # Visual diff and merge tool
      nil # Nix language server
      nix-tree # Visualize Nix dependencies

      # Containers
      podman # Tool for managing OCI containers

      # Fonts
      cantarell-fonts # Cantarell font family

      # Other
      awscli2 # AWS command-line interface
      fuse-emulator # ZX Spectrum emulator
      oath-toolkit # OATH one-time password tool
      protonvpn-cli_2 # ProtonVPN command-line interface
    ];

    sessionVariables = {
      LIBGL_ALWAYS_INDIRECT = 1;
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
      KPT_FN_RUNTIME = "podman";
    };
  };

  module = {
    avizo.enable = true;
    foot.enable = true;
    fuzzel.enable = true;
    gammastep.enable = true;
    kanshi.enable = true;
    mhalo = {
      enable = true;
      swayKeybinding = "Mod4+Shift+m";
    };
    tmux.enable = true;
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
          iconSha256 = "sha256-dPnIsztCpcAID2DYjZFN3QSCvE8K6bzC9v7TQkDq3oY=";
        };
        "tiberian-dawn" = {
          enable = true;
          appimageSha256 = "sha256-s9IC0b9wG+WYnEHCVtGb0rF4hpTfAeNDrehlzxGQcGs=";
          iconSha256 = "sha256-dPnIsztCpcAID2DYjZFN3QSCvE8K6bzC9v7TQkDq3oY=";
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
      systemdIntegration.enable = true;
    };
  };
}
