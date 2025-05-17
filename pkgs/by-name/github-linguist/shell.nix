{
  mkShell,
  bundler,
  bundix,
}:
mkShell {
  packages = [
    bundler
    bundix
  ];
}
