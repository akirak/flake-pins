{
  emacs,
  lib,
  stdenv,
  webkitgtk,
  glib-networking,
}:
(emacs.overrideAttrs
  (old: {
    buildInputs =
      old.buildInputs
      ++ [glib-networking]
      ++ lib.optionals stdenv.isLinux [
        webkitgtk
      ];
  }))
.override {
  withXwidgets = true;
}
