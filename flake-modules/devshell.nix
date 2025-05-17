{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        # Add global devShells for scaffolding new projects

        pnpm = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_latest
            pkgs.nodePackages_latest.pnpm
          ];
        };

        yarn = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_latest
            pkgs.yarn
          ];
        };

        npm = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_latest
          ];
        };
      };
    };
}
