{
  inputs = {
    systems.url = "github:nix-systems/default";

    cli-tools = {
      url = "path:./cli-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts = {
      url = "path:./fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    data = {
      url = "path:./data";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    media = {
      url = "path:./media";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-plugins.url = "path:./zsh-plugins";
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        nixpkgs.lib.mergeAttrsList (
          builtins.map (name: inputs.${name}.packages.${system} or { }) [
            "cli-tools"
            "data"
            "fonts"
            "media"
            "zsh-plugins"
          ]
        )
      );
    };
}
