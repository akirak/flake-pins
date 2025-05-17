let
  # lib.importJSON is too trivial to use in here
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  nodes = lock.nodes;

  rootInputs = nodes.${lock.root}.inputs;
in
assert (lock.version == 7);
builtins.mapAttrs (
  _: input: builtins.getFlake (builtins.flakeRefToString nodes.${input}.locked)
) rootInputs
