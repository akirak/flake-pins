# Nix Flake Pins
This repository tracks flake inputs so I am ensured to have a consistent set of
input revisions among multiple projects without having cyclic dependencies
between flakes.
## Usage
### Pinned Flake Registry
This repository provides a flake registry. You can use the following command to
update the flake in the current directory from the registry:

``` shell
nix flake update --flake-registry https://raw.githubusercontent.com/akirak/flake-pins/master/registry.json
```

Alternatively, you can use the following command:

``` shell
nix run github:akirak/flake-pins#apply
```
### Custom Packages on Pinned Registry
This repository also contains a subflake (in `pkgs` directory) that provides custom Nix packages.

You can browse the packages:

``` shell
nix flake show 'github:akirak/flake-pins?dir=pkgs' --impure --allow-import-from-derivation
```
