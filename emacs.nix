{
  emacs,
  lib,
  stdenv,
  webkitgtk,
}:
emacs.overrideAttrs
(old: {
  buildInputs =
    old.buildInputs
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.webkitgtk
    ];
})
.override {
  withXwidgets = true;
}
