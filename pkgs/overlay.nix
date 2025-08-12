{ inputs }:
final: prev:
let
  inherit (builtins) mapAttrs;

  inherit (prev)
    lib
    stdenv
    system
    callPackage
    runCommandLocal
    ;

  # Prevent rebuild of huge packages when the overlay is applied on different
  # pkgs revisions.
  pinnedNixosUnstable = import inputs.unstable {
    inherit system;
    config.allowUnfree = true;
  };
  pinnedNixpkgsUnstable = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  flakePackages = builtins.mapAttrs (_: outputs: outputs.packages.${system}) (import ../deps/flakes);

  sources = import ../deps/non-flakes;

  overrideSources =
    names:
    prev.lib.genAttrs names (
      name:
      prev.${name}.overrideAttrs {
        src = sources.${name};
      }
    );

  makeFont =
    name:
    { pattern }:
    stdenv.mkDerivation {
      inherit name;

      src = sources.${name};

      dontBuild = true;

      installPhase = ''
        fontDir=$out/share/fonts/truetype
        mkdir -p $fontDir
        ls
        cp ${pattern} $fontDir
      '';
    };

  customFontPackages = mapAttrs makeFont {
    jetbrains-mono-nerdfont = {
      pattern = "*.ttf";
    };
  };

  makeZshPlugin =
    name: meta:
    runCommandLocal name
      {
        inherit meta;
      }
      ''
        cp -r ${sources.${name}} $out
      '';

  customZshPlugins = mapAttrs makeZshPlugin {
    "zsh-auto-notify" = {
      description = "ZSH plugin that automatically sends out a notification when a long running task has completed.";
      homepage = "https://github.com/MichaelAquilina/zsh-auto-notify";
    };
    "zsh-fzy" = {
      description = "Use the fzy fuzzy-finder in Zsh";
      homepage = "https://github.com/aperezdc/zsh-fzy";
    };
    "zsh-nix-shell" = {
      description = "zsh plugin that lets you use zsh in nix-shell shells.";
      homepage = "https://github.com/chisui/zsh-nix-shell";
    };
    "zsh-fast-syntax-highlighting" = {
      description = "Feature-rich syntax highlighting for ZSH";
      homepage = "https://github.com/zdharma-continuum/fast-syntax-highlighting";
    };
    "zsh-history-filter" = {
      description = "Zsh plugin to filter out some commands from being added to you history";
      homepage = "https://github.com/MichaelAquilina/zsh-history-filter";
    };
  };
in
{
  customPackages = {
    # pinned packages from external flakes
    # Is it better to declare these as custom packages?
    epubinfo = flakePackages.epubinfo.default;
    squasher = flakePackages.squasher.default;

    # a custom wrapper for exiting packages
    d2-format = callPackage ./by-name/d2-format { };

    # a variant of existing packages in nixpkgs
    ffmpeg-qsv = pinnedNixosUnstable.callPackage ./by-name/ffmpeg/qsv.nix { src = sources.ffmpeg; };

    # unpackaged in nixpkgs
    github-linguist = callPackage ./by-name/github-linguist { };

    codex-cli = pinnedNixpkgsUnstable.callPackage ./by-name/codex-cli { src = sources.codex; };

    java-debug-plugin = pinnedNixpkgsUnstable.callPackage ./by-name/java-debug {
      src = sources.java-debug;
    };
  };

  customDataPackages = {
    # data packages
    wordnet-sqlite = callPackage ./by-name/wordnet-sqlite { inherit sources; };
  };

  # Explicitly declare as custom packages.
  inherit customFontPackages customZshPlugins;
}
// (lib.optionalAttrs stdenv.isLinux (overrideSources [
  "dpt-rp1-py"
  "intel-media-driver"
]))
