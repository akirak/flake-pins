{
  inputs = {
    systems.url = "github:nix-systems/default";

    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };
    zsh-fast-syntax-highlighting = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
      flake = false;
    };
    zsh-nix-shell = {
      url = "github:chisui/zsh-nix-shell";
      flake = false;
    };
    zsh-fzy = {
      url = "github:aperezdc/zsh-fzy";
      flake = false;
    };
    zsh-history-filter = {
      url = "github:MichaelAquilina/zsh-history-filter";
      flake = false;
    };
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (
        pkgs:
        builtins.mapAttrs
          (
            name: meta:
            pkgs.runCommandLocal name
              {
                inherit meta;
              }
              ''
                cp -r ${inputs.${name}.outPath} $out
              ''
          )
          {
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
          }
      );
    };
}
