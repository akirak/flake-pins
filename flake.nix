{
  inputs.stable.url = "nixpkgs/nixos-22.11";
  inputs.unstable.url = "nixpkgs/nixos-unstable";

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
