{
  description = "Custom CLI tools that can be integrated into Emacs and NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable?dir=lib";
    epubinfo.url = "github:akirak/epubinfo";
    squasher.url = "github:akirak/squasher";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        epubinfo = inputs.epubinfo.packages.${system}.default;
        squasher = inputs.squasher.packages.${system}.default;
      });
    };
}
