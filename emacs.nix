{
  emacs,
  lib,
  stdenv,
  webkitgtk,
}:
(emacs.overrideAttrs
  (old: {
    buildInputs =
      old.buildInputs
      ++ lib.optionals stdenv.isLinux [
        webkitgtk
      ];
  }))
.override {
  withXwidgets = true;
}
