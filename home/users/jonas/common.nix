{ pkgs, ... }:
{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    nh = {
      enable = true;
      flake = "/etc/nixos";
      clean.enable = true;
    };
  };

  # Install packages for user.
  # Search for packages here: https://search.nixos.org/packages
  home = {
    packages = with pkgs; [
      # File Management
      aria2 # Download utility
      fd # File search utility
      lsof # List open files
      tree # Directory tree viewer
      unzip # Unzip utility
      wget # Download utility
      zip # Zip utility

      # Media
      mpg123 # Audio player
      mpv # Video player

      # Development Tools
      fzf # Fuzzy finder
      ripgrep # Search tool

      # Version Control
      tig # Text-mode interface for Git

      # File and Text Manipulation
      glow # Markdown renderer for the terminal
      jaq # JSON processor
      xh # Friendly and fast HTTP client

      # Diagramming Tools
      d2 # Modern diagram scripting language

      # Other
      firefox # Web browser
      google-chrome # Web browser
      telegram-desktop # Telegram client
    ];

    sessionVariables = {
      LESS = "-iXFR";
      BUILDKIT_PROGRESS = "plain";
    };

    stateVersion = "24.05";
  };

  module = {
    git.enable = true;
    gpg-agent.enable = true;
    kitty.enable = true;
    neovim.enable = true;
    ollama = {
      enable = true;
      acceleration = false;
    };
    tmux.enable = true;
    zsh.enable = true;
  };
}
