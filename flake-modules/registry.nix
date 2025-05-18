{ inputs, ... }:
{
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
