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
    { system, pkgs, ... }:
    let
      packagesFromOverlay = takePackages pkgs [
        # You have to list individual packages here
        "dpt-rp1-py"
        "intel-media-driver"
        "epubinfo"
        "squasher"
        "zsh-auto-notify"
        "zsh-fzy"
        "zsh-nix-shel"
        "zsh-fast-syntax-highlighting"
        "zsh-history-filter"
        "d2-format"
        "ffmpeg-qsv"
        "github-linguist"
        "wordnet-sqlite"
        "jetbrains-mono-nerdfont"
        "shippori-mincho-otf"
        # "r8168"
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
