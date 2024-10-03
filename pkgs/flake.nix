{
  inputs = {
    systems.url = "github:nix-systems/default";

    cli-tools = {
      url = "path:./cli-tools";
      flake = false;
    };
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: inputs.cli-tools.packages.${system});
    };
}
