{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-25.05";
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
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        ./flake-modules/emacs.nix
        ./flake-modules/registry.nix
        ./flake-modules/devshell.nix
        ./flake-modules/overlay.nix
      ];
      perSystem =
        {
          pkgs,
          system,
          self',
          lib,
          ...
        }:
        {
          checks = lib.mapAttrs' (name: drv: lib.nameValuePair ("build-" + name) drv) self'.packages;
        };
    };
}
