{ pkgs, ... }:
with pkgs;
let
  lsp =
    if builtins.hasAttr "rnix-lsp" pkgs then
      rnix-lsp
    else if builtins.hasAttr "nil" pkgs then
      nil
    else
      null;
in
mkShell {
  name = "development-nix";

  # Paket-paket yang dibutuhkan untuk development Nix + editor support (LSP, formatter, linter)
  buildInputs = [
    nix
    nixpkgs-fmt
    nixfmt-rfc-style
    nixfmt
    alejandra
    statix
    deadnix
    direnv
    gnumake
    git
    nixfmt
  ]
  ++ lib.optionals (lsp != null) [ lsp ];

  packages = [
    (writeShellScriptBin "help_me" ''
      echo "🚀 Nix development shell ready!"
      echo ""
      echo "Available tools:"
      echo "  - nix: Nix package manager"
      echo "  - nixpkgs-fmt: Formatter for nixpkgs style"
      echo "  - nixfmt: Another Nix formatter"
      echo "  - nil: Nix language server (LSP)" 
      echo "  - alejandra: Another Nix formatter"
      echo "  - rnix-lsp: Nix language server (LSP)"
      echo "  - statix: Linter for Nix"
      echo "  - direnv: handy env loader for development"
      echo ""
      echo "Usage tips:" 
      echo "  1) Open VS Code from this shell so the LSP binary is on PATH:"
      echo "     $ nix develop && code ."
      echo "  2) Install a Nix extension in VS Code that supports rnix-lsp (search 'nix' in the marketplace)."
      echo "  3) Enable format-on-save and choose your preferred formatter (nixpkgs-fmt or alejandra)."
      echo ""
      echo "Nix version: $(nix --version)"
    '')
  ];

  # Environment variables untuk Nix
  shellHook = ''
    if [ -z "$SHELL_INITIALIZED" ]; then
        export SHELL_INITIALIZED=1
        export TMP_DIR=$(mktemp -d -t "myapp-$(date +%s)-XXXXXX")
        export NIX_PATH="nixpkgs=${pkgs.path}"
        help_me
    fi
  '';
}
