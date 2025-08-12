{
  src,
  lib,
  maven,
  makeWrapper,
}:
let
  version = "0.53.2";
in
maven.buildMavenPackage {
  pname = "java-debug";

  inherit version src;

  mvnHash = "sha256-tfeO0+K0vug+liRt4+XqLh9beSN2N1WaGC2jl/7+oGg=";

  buildOffline = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/share

    dir="com.microsoft.java.debug.plugin/target"
    jar="$dir/com.microsoft.java.debug.plugin-${version}.jar"

    install -v "$jar" $out/share/java-debug-plugin.jar
  '';

  meta = {
    homepage = "https://github.com/microsoft/java-debug";
    description = "The debug server implementation for Java. It conforms to the debug protocol of Visual Studio Code (DAP, Debugger Adapter Protocol).";
    license = lib.licenses.epl10;
  };
}
