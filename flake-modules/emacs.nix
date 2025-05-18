{ inputs, ... }:
{
  flake = {
    # emacs-snapshot in nix-emacs-ci corresponds to emacs-git in emacs-overlay
    data.emacs = inputs.emacs-builtins.data.emacs-snapshot;
  };

  perSystem =
    { system, ... }:
    {
      packages = {
        emacs = inputs.emacs-overlay.packages.${system}.emacs-git;
        emacs-pgtk = inputs.emacs-overlay.packages.${system}.emacs-git-pgtk;
      };
    };
}
