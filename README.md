# Nix Flake Pins
This repository tracks flake inputs so I am ensured to have a consistent set of
input revisions among multiple projects without having cyclic dependencies
between flakes.
## Usage
This repository provides a flake registry. You can use the following command to
update the flake in the current directory from the registry:

``` shell
nix flake update --flake-registry https://raw.githubusercontent.com/akirak/flake-pins/master/registry.json
```

Alternatively, you can use the following command:

``` shell
nix run github:akirak/flake-pins#apply
```
