{
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs,
  npmHooks,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "h5i";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "h5i-dev";
    repo = "h5i";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCISqiVzm78WuG+/C/jPo+NtwEYVnW01WMhVzoB8mRg=";
  };

  cargoHash = "sha256-29aEIIvcWDD1dv9lbai+h1ZF9FV2O3ihquW33rpqCyQ=";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/web";
    hash = "sha256-oxkZJHNSVuNd4FE0WBIAggjL4xyD189IOnmauwSgmLw=";
  };

  npmRoot = "web";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  # The test suite includes integration tests that need a browser and network.
  doCheck = false;

  meta = {
    description = "Web framework and development infrastructure for formal verification and red-teaming";
    homepage = "https://github.com/h5i-dev/h5i";
    license = lib.licenses.asl20;
    mainProgram = "h5i";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
