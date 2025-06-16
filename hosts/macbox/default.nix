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
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllFiles = true;
    NSGlobalDomain.AppleKeyboardUIMode = 3;
  };

  time.timeZone = "Europe/Stockholm";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = null;
  };

  users.users.jonas = {
    home = "/Users/jonas";
    shell = pkgs.zsh;
  };

  environment = {
    systemPackages = with pkgs; [
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
