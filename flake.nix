{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Update home-manager when nixpkgs is updated
    home-manager = {
      url = "github:nix-community/home-manager";
      # This doesn't work
      # inputs.nixpkgs.follows = "unstable";
      inputs.utils.follows = "flake-utils";
    };

    # I never use Darwin, but some flakes depend on it.
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs-stable.follows = "stable";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-images = {
      url = "github:nix-community/nixos-images";
      inputs.nixos-2211.follows = "nixpkgs";
      inputs.nixos-unstable.follows = "unstable";
    };

    nixos-remote = {
      url = "github:numtide/nixos-remote";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixos-images.follows = "nixos-images";
      inputs.disko.follows = "disko";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    cachix-deploy-flake = {
      url = "github:cachix/cachix-deploy-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "nix-darwin";
      inputs.nixos-remote.follows = "nixos-remote";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://akirak.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "akirak.cachix.org-1:WJrEMdV1dYyALkOdp/kAECVZ6nAODY5URN05ITFHC+M="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    unstable,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        unstablePkgs = unstable.legacyPackages.${system};
      in {
        packages = {
          emacs-pgtk = pkgs.callPackage ./emacs.nix {
            emacs = inputs.emacs-overlay.packages.${system}.emacs-pgtk;
          };

          registry = pkgs.callPackage ./registry.nix {};

          apply = pkgs.writeShellScriptBin "apply" ''
            nix flake update \
              --extra-experimental-features nix-command \
              --extra-experimental-features flakes \
              --inputs-from ${self.outPath}
          '';
        };

        devShells = {
          # Add global devShells for scaffolding new projects

          pnpm = pkgs.mkShell {
            buildInputs = [
              unstablePkgs.nodejs_latest
              unstablePkgs.nodePackages_latest.pnpm
            ];
          };

          yarn = pkgs.mkShell {
            buildInputs = [
              unstablePkgs.nodejs_latest
              unstablePkgs.yarn
            ];
          };

          npm = pkgs.mkShell {
            buildInputs = [
              unstablePkgs.nodejs_latest
            ];
          };

          elixir = pkgs.mkShell {
            buildInputs = [
              unstablePkgs.elixir
            ];
          };
        };
      }
    );
}
