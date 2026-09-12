{
  inputs = {
    # Should be the same as the one used in the main flake.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    epubinfo.url = "github:akirak/epubinfo";
    squasher.url = "github:akirak/squasher";
    capnp-ls = {
      url = "github:akirak/capnp-ls/develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = _: { };
}
