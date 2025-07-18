# See https://github.com/nixos/nixpkgs/blob/nixpkgs-unstable/doc/languages-frameworks/javascript.section.md#pnpm-javascript-pnpm
{
  lib,
  stdenv,
  nodejs,
  pnpm,
  makeWrapper,
  src,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "codex-cli";
  version = "0.0.0-dev";
  inherit src;

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
  ];

  pnpmWorkspaces = [
    "@openai/codex"
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src pnpmWorkspaces;
    hash = "sha256-SyKP++eeOyoVBFscYi+Q7IxCphcEeYgpuAj70+aCdNA=";
    fetcherVersion = 1;
  };

  buildPhase = ''
    pnpm run build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/bin

    # cp -r node_modules $out/share/node_modules

    install -m 644 codex-cli/package.json $out/share/package.json
    install -m 755 codex-cli/dist/cli.js $out/share/bin/cli.js

    ln -s $out/share/bin/cli.js $out/bin/codex

    wrapProgram $out/bin/codex \
      --prefix PATH : "${nodejs}/bin"

    runHook postInstall
  '';

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    license = lib.licenses.asl20;
    homepage = "https://github.com/openai/codex";
    mainProgram = "codex";
  };
})
