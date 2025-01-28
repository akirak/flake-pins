{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ffmpeg = {
      url = "github:FFmpeg/FFmpeg/release/7.1";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://akirak.cachix.org"
    ];
    extra-trusted-public-keys = [
      "akirak.cachix.org-1:WJrEMdV1dYyALkOdp/kAECVZ6nAODY5URN05ITFHC+M="
    ];
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs [ "x86_64-linux" ];
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          # ffmpeg build for intel GPU. Supports *_qsv encoders
          ffmpeg-qsv = pkgs.callPackage ./ffmpeg/qsv.nix {
            src = # Switch back to the released revision once the VPL support
              # becomes stable. I will keep updating until 7.2 or 8.0 is
              # released.
              assert (lib.versions.majorMinor pkgs.ffmpeg.version == "7.1");
              inputs.ffmpeg;
          };
        }
      );
    };
}
