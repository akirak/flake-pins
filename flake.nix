{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-unstable.url = "github:nix-community/home-manager";

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
    flake-parts.url = "github:hercules-ci/flake-parts";
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

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      flake = {
        # emacs-snapshot in nix-emacs-ci corresponds to emacs-git in emacs-overlay
        data.emacs = inputs.emacs-builtins.data.emacs-snapshot;
      };
      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          packages = {
            emacs = inputs.emacs-overlay.packages.${system}.emacs-git;

            emacs-pgtk = inputs.emacs-overlay.packages.${system}.emacs-pgtk;

            registry = pkgs.callPackage ./registry.nix { };

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
                pkgs.nodejs_latest
                pkgs.nodePackages_latest.pnpm
              ];
            };

            yarn = pkgs.mkShell {
              buildInputs = [
                pkgs.nodejs_latest
                pkgs.yarn
              ];
            };

            npm = pkgs.mkShell {
              buildInputs = [
                pkgs.nodejs_latest
              ];
            };
          };
        };
    };
}
