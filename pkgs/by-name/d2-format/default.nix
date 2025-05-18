# A wrapper for `d2 fmt` command to make it conform to the API of reformatter.el
{
  writeShellApplication,
  d2,
}:
writeShellApplication {
  name = "d2-format";
  runtimeInputs = [ d2 ];
  text = ''
    orig=$(mktemp -t format-orig-XXX.d2)
    new=$(mktemp -t format-new-XXX.d2)
    tee "$orig" | d2 fmt - > "$new"
    if [[ -s "$new" ]]
    then
      cat "$new"
    else
      cat "$orig"
    fi
  '';
}
