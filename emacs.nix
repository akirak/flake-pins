{
  emacs,
  tree-sitter-grammars,
  lib,
  stdenv,
  # webkitgtk,
  # glib-networking,
}:
emacs.override (old: {
  treeSitterPlugins =
    lib.pipe tree-sitter-grammars
    [
      (lib.filterAttrs (name: _: name != "recurseForDerivations"))
      builtins.attrValues
    ];
})
# (emacs.overrideAttrs
#   (old: {
#     buildInputs =
#       old.buildInputs
#       ++ [glib-networking]
#       ++ lib.optionals stdenv.isLinux [
#         webkitgtk
#       ];
#   }))
# .override {
#   withXwidgets = true;
# }
