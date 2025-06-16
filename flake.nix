{
  description = "Nix flake configuration for NixOS and macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    };

    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      darwin,
      home-manager,
      ...
    }:
    let
      nixbox-arch = "x86_64-linux";
      macbox-arch = "aarch64-darwin";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        nixbox-arch
        macbox-arch
      ];

      imports = [ inputs.dev-flake.flakeModule ];

      # Dev configuration
      dev.name = "nixbox";

      # Per-system configuration
      perSystem =
        { config, pkgs, ... }:
        {
          treefmt = import ./dev/treefmt.nix { inherit pkgs; };
          pre-commit = import ./dev/pre-commit.nix;

          packages = {
            pre-commit = config.pre-commit.settings.package;
            pre-commit-install = pkgs.writeShellScriptBin "pre-commit-install" ''
              #!${pkgs.stdenv.shell}
              ${pkgs.pre-commit}/bin/pre-commit install
            '';
          };

          devshells.default = {
            packages = with pkgs; [
              deadnix
              statix
            ];
          };
        };

      flake = {
        formatter = {
          ${nixbox-arch} = inputs.nixpkgs.legacyPackages.${nixbox-arch}.nixfmt-rfc-style;
          ${macbox-arch} = inputs.nixpkgs.legacyPackages.${macbox-arch}.nixfmt-rfc-style;
        };

        # NixOS configuration
        nixosConfigurations.nixbox = inputs.nixpkgs.lib.nixosSystem {
          system = nixbox-arch;
          modules = [
            ./hosts/nixbox/default.nix
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.jonas = {
                  imports = [
                    ./home/users/jonas/linux.nix

                    # Linux-specific modules
                    ./modules/common/git/default.nix
                    ./modules/common/gpg-agent/default.nix
                    ./modules/common/neovim/default.nix
                    ./modules/common/ollama/default.nix
                    ./modules/common/tmux/default.nix
                    ./modules/common/zsh/default.nix
                    ./modules/linux/avizo/default.nix
                    ./modules/linux/foot/default.nix
                    ./modules/linux/fuzzel/default.nix
                    ./modules/linux/gammastep/default.nix
                    ./modules/linux/kanshi/default.nix
                    ./modules/linux/mhalo/default.nix
                    ./modules/linux/openra/default.nix
                    ./modules/linux/sway/default.nix
                    ./modules/linux/waybar/default.nix
                  ];
                };
              };
            }
          ];
        };

        # macOS configuration
        darwinConfigurations.macbox = darwin.lib.darwinSystem {
          system = macbox-arch;
          modules = [
            ./hosts/macbox/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.jonas = {
                  imports = [
                    ./home/users/jonas/darwin.nix

                    # macOS-compatible modules
                    ./modules/common/git/default.nix
                    ./modules/common/gpg-agent/default.nix
                    ./modules/common/neovim/default.nix
                    ./modules/common/ollama/default.nix
                    ./modules/common/tmux/default.nix
                    ./modules/common/zsh/default.nix
                  ];
                };
              };
            }
          ];
        };
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
