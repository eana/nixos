{
  config,
  pkgs,
  ...
}:
let
  # Do not change this value! This tracks when NixOS was installed on your system.
  stateVersion = "24.05";
in
{
  time.timeZone = "Europe/Stockholm";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = null;
  };

  homebrew = {
    enable = true;
    casks = [
      "google-chrome"
      "docker"
    ];
    masApps = {
      Bitwarden = 1352778147;
    };
    onActivation.cleanup = "zap";
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  nix-homebrew = {
    enable = true;
    user = "jonas";
    enableRosetta = true;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
    mutableTaps = false;
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.philip = {
      imports = [ ../../home/users/jonas/darwin.nix ];
      home.packages = [
        pkgs.spotify
      ];
    };
  };

  system = {
    primaryUser = "jonas";

    # pkgs apps will be visible in Spotlight
    activationScripts.applications.text =
      let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
      pkgs.lib.mkForce ''
        # Set up system applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
        # Set up home-manager applications.
        cd "${config.users.users.philip.home}/Applications/Home Manager Apps/"
        find . -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

    defaults = {
      dock.autohide = true;
      dock.persistent-apps = [
        "/Applications/Google Chrome.app"
        "/System/Applications/Utilities/Terminal.app"
      ];
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
    };

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;
  };

  # Sudo with fingerprint
  security.pam.services.sudo_local.touchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment = {
    systemPackages = with pkgs; [
      mkalias # Make APFS aliases without going via AppleScript
      home-manager # Nix-based user environment configurator

      jetbrains.idea-community-bin
      m-cli # Swiss-army knife for macOS
      vscode
      zsh-powerlevel10k
    ];

    pathsToLink = [ "/Applications" ]; # For GUI apps
    variables = {
      EDITOR = "nvim";
    };
  };

  services.nix-daemon.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
      trusted-users = [
        "root"
        "jonas"
      ];
    };
  };

  system.stateVersion = stateVersion;
}
