{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.stable.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nix.url = "github:NixOS/nix";

  # Update home-manager when nixpkgs is updated
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    # This doesn't work
    # inputs.nixpkgs.follows = "unstable";
    inputs.utils.follows = "flake-utils";
  };

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs-stable.follows = "stable";
    inputs.nixpkgs.follows = "unstable";
    inputs.flake-utils.follows = "flake-utils";
  };

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  inputs.lean4 ={
    url = "github:leanprover/lean4";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-utils.follows = "flake-utils";
      nix.follows = "nix";
    };
  };
  inputs.lake = {
    url = "github:leanprover/lake";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-utils.follows = "flake-utils";
      lean.follows = "lean4";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    packages =
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ] (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        emacs-pgtk =
          inputs.emacs-overlay.packages.${system}.emacsPgtk;

        lake = inputs.lake.packages.${system}.cli;

        registry = pkgs.callPackage ./registry.nix {};

        apply = pkgs.writeShellScriptBin "apply" ''
          nix flake update \
            --extra-experimental-features nix-command \
            --extra-experimental-features flakes \
            --inputs-from ${self.outPath}
        '';
      });
  };
}
