{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.module.neovim;

  nvimConfigDir = ../../../assets/.config/nvim;

  commonDeps = with pkgs; [
    # Formatters
    go
    gopls
    nixpkgs-fmt
    nodePackages.prettier
    terraform

    # PDF and LaTeX tools
    ghostscript
    tectonic
    texlive.combined.scheme-small

    # Mermaid diagrams
    nodePackages.mermaid-cli

    # LazyGit
    lazygit

    # conform.nvim
    gotools

    # LuaRocks
    luarocks

    # fzf-lua
    chafa
    ueberzugpp
    viu

    # Mason dependencies
    bash
    gcc
    gnutar
    gzip
    nodejs
    python3
    python3Packages.pip
    unzip
    wget

    # Other tools
    ast-grep
    imagemagick
    sqlite
    tree-sitter
  ];

in
{
  options.module.neovim = {
    enable = mkEnableOption "Neovim text editor";

    vimAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to create a 'vim' alias for Neovim";
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Node.js support";
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to set Neovim as the default editor";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional Neovim configuration to append";
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of Neovim plugins to install";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional runtime dependencies";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ (lib.mkIf cfg.withNodeJs nodejs) ] ++ commonDeps ++ cfg.extraPackages;

    xdg.configFile."nvim" = {
      source = nvimConfigDir;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      inherit (cfg)
        vimAlias
        withNodeJs
        defaultEditor
        plugins
        ;

      inherit (cfg) extraConfig;

      extraLuaPackages = ps: with ps; [ ];
    };
  };
}
