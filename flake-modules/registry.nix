{ lib, inputs, ... }:
{
  flake = {
    lib = {
      nix-registry = lib.pipe (lib.importJSON (../registry.json)).flakes [
        (map ({ from, to }: lib.nameValuePair from.id { inherit from to; }))
        lib.listToAttrs
      ];
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        registry = pkgs.callPackage ../registry.nix { };

        apply = pkgs.writeShellScriptBin "apply" ''
          nix flake update \
            --extra-experimental-features nix-command \
            --extra-experimental-features flakes \
            --inputs-from ${inputs.self.outPath}
        '';
      };
    };
}
