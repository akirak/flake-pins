{
  inputs = {
    dpt-rp1-py = {
      url = "github:akirak/dpt-rp1-py/nixpkgs-workaround";
      flake = false;
    };
    intel-media-driver = {
      url = "github:intel/media-driver";
      flake = false;
    };
    ffmpeg = {
      url = "github:FFmpeg/FFmpeg/release/7.1";
      flake = false;
    };
    wn2sql = {
      url = "https://github.com/rbergmair/wn2sql/releases/download/v0.99.4a/wn2sql-0.99.4a.tar";
      flake = false;
    };

    # fonts
    jetbrains-mono-nerdfont = {
      url = "tarball+https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip";
      flake = false;
    };
    shippori-mincho-otf = {
      url = "tarball+https://fontdasu.com/download/shippori3.zip";
      flake = false;
    };

    # zsh plugins
    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };
    zsh-fast-syntax-highlighting = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
      flake = false;
    };
    zsh-nix-shell = {
      url = "github:chisui/zsh-nix-shell";
      flake = false;
    };
    zsh-fzy = {
      url = "github:aperezdc/zsh-fzy";
      flake = false;
    };
    zsh-history-filter = {
      url = "github:MichaelAquilina/zsh-history-filter";
      flake = false;
    };
  };

  outputs = _: { };
}
