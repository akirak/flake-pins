# This default.nix is kept for allowing non-flake access to the flake outputs
# from some places. When using only some parts of the flake, it's nice to avoid
# inclusion of indirect inputs.
(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in
  fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  }
) { src = ./.; }).defaultNix
