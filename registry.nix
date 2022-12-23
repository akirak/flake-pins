{
  writeTextFile,
  lib,
}: let
  inherit (builtins) toJSON hasAttr;
  inherit (lib) mapAttrsToList importJSON;

  inherit (importJSON ./flake.lock) nodes;

  flakes =
    mapAttrsToList (
      id: name: {
        from = {
          inherit id;
          type = "indirect";
        };

        to =
          nodes.${name}.locked;
      }
    )
    nodes.root.inputs;
in
  writeTextFile {
    name = "registry.json";
    text = toJSON {
      version = 2;
      inherit flakes;
    };
  }
