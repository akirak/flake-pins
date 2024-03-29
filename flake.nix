{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-23.05";
    home-manager-unstable.url = "github:nix-community/home-manager";

    # Needed to provide Emacs executables from default.nix
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # I never use Darwin, but some flakes depend on it.
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-builtins.url = "github:emacs-twist/emacs-builtins";

    ocaml-overlays.url = "github:nix-ocaml/nix-overlays";
    ocaml-overlays.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";
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
    systems,
    ...
  } @ inputs:
    {
      # emacs-snapshot in nix-emacs-ci corresponds to emacs-git in emacs-overlay
      data.emacs = inputs.emacs-builtins.data.emacs-snapshot;
    }
    // flake-utils.lib.eachSystem (import systems) (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        unstablePkgs = unstable.legacyPackages.${system};
      in {
        packages = {
          emacs = inputs.emacs-overlay.packages.${system}.emacs-git;

          emacs-pgtk = inputs.emacs-overlay.packages.${system}.emacs-pgtk;

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
        };
      }
    );
}
