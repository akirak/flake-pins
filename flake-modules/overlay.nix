{ lib, inputs, ... }:
let
  overlay = import ../pkgs/overlay.nix;

  makeAttrsetsWithNames = names: lib.genAttrs names (_: null);

  takePackages = pkgs: names: builtins.intersectAttrs (makeAttrsetsWithNames names) pkgs;
in
{
  flake = {
    overlays.default = overlay;
  };

  perSystem =
    {
      system,
      lib,
      pkgs,
      ...
    }:
    let
      packagesFromOverlay = lib.mergeAttrsList [
        pkgs.customPackages
        pkgs.customDataPackages
        pkgs.customFontPackages
        pkgs.customZshPlugins
        (takePackages pkgs [
          # You have to list individual packages here
          "dpt-rp1-py"
          "intel-media-driver"
        ])
      ];
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          overlay
        ];
      };
      packages = packagesFromOverlay;
    };
}
