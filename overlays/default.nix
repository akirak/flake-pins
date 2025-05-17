let
  sources = import ../deps/non-flakes;

  overrideSources =
    names: prev:
    prev.lib.genAttrs names (
      name:
      prev.${name}.overrideAttrs {
        src = sources.${name};
      }
    );
in
final: prev:
if prev.stdenv.isLinux then
  overrideSources [
    "dpt-rp1-py"
    "intel-media-driver"
  ] prev
else
  { }
