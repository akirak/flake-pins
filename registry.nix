{
  writeTextFile,
  lib,
}: let
  inherit (builtins) toJSON hasAttr;
  inherit (lib) filterAttrs mapAttrsToList importJSON;

  inherit (importJSON ./flake.lock) nodes;

  flakes = lib.pipe nodes [
    (filterAttrs (
      name: value:
        hasAttr name nodes.root.inputs
        && (value.flake or true)
    ))
    (mapAttrsToList (id: value: {
      from = {
        inherit id;
        type = "indirect";
      };

      to =
        value.locked;
    }))
  ];
in
  writeTextFile {
    name = "registry.json";
    text = toJSON {
      version = 2;
      inherit flakes;
    };
  }
