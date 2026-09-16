{
  writeTextFile,
  lib,
}:
let
  inherit (builtins) toJSON hasAttr;
  inherit (lib) mapAttrsToList importJSON;

  inherit (importJSON ./flake.lock) nodes;

  flakes = mapAttrsToList (id: names: {
    from = {
      inherit id;
      type = "indirect";
    };

    to = nodes.${if builtins.typeOf names == "string" then names else builtins.elemAt names 0}.locked;
  }) nodes.root.inputs;
in
writeTextFile {
  name = "registry.json";
  text = toJSON {
    version = 2;
    inherit flakes;
  };
}
