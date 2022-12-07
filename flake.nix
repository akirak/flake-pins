{
  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    packages =
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ] (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        apply = pkgs.writeShellScriptBin "apply" ''
          ${pkgs.nix}/bin/nix flake update \
            --extra-experimental-features nix-command \
            --extra-experimental-features flakes \
            --inputs-from ${self.outPath}
        '';
      });
  };
}
