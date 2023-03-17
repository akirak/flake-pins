{
  emacs,
  tree-sitter-grammars,
  lib,
  stdenv,
  # webkitgtk,
  # glib-networking,
}:
emacs.override {
  treeSitterPlugins = with tree-sitter-grammars; [
    tree-sitter-elixir
    tree-sitter-heex
  ];
}
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
