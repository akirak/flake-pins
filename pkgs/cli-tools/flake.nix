{
  description = "Custom CLI tools that can be integrated into Emacs and NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    epubinfo.url = "github:akirak/epubinfo";
    squasher.url = "github:akirak/squasher";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.0.1.tar.gz";
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          epubinfo = inputs.epubinfo.packages.${system}.default;
          squasher = inputs.squasher.packages.${system}.default;
          github-linguist = pkgs.callPackage ./github-linguist { };
        }
      );

      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          github-linguist = pkgs.mkShell {
            buildInputs = [
              pkgs.bundler
              pkgs.bundix
            ];
          };
        }
      );
    };
}
