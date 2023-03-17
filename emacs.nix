{
  emacs,
  tree-sitter-grammars,
  lib,
  stdenv,
  # webkitgtk,
  # glib-networking,
}:
emacs.override (old: {
  treeSitterPlugins = with tree-sitter-grammars; old.treeSitterPlugins ++ [
    tree-sitter-elixir
    tree-sitter-heex
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
