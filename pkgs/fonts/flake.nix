{
  inputs = {
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { systems, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      eachSystem = f: lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (
        pkgs:
        lib.genAttrs [
          "shippori-mincho"
          "jetbrains-mono-nerdfont"
        ] (name: pkgs.callPackage (./. + "/${name}.nix") { })
      );
    };
}
