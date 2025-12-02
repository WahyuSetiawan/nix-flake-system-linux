Purpose
-------

This workspace `.vscode` contains recommended settings to work with the `dev-nix` development shell.

What this does
- Associates Nix files with the Nix language in VS Code
- Enables format-on-save for supported formatters
- Enables `direnv` integration (install extension + ensure direnv is configured)

Recommended extensions (search and install from VS Code Marketplace)
- Nix (search for "Nix" / "nix-community") — provides Nix syntax support and LSP integration
- direnv (extension id: `direnv.direnv`) — integrates direnv into VS Code

How to use with the dev shell (ensures LSP/formatters are available on PATH)
1. From your project root open a fish shell and run:

```fish
nix develop .#devShells.x86_64-linux.development-nix
code .
```

This opens VS Code with binaries from the dev shell (like `rnix-lsp`, `nixpkgs-fmt`, `alejandra`) available in PATH so the editor can start the language server and formatters.

If you prefer direnv
1. Ensure `.envrc` invokes the flake dev shell or `use flake`.
2. Run `direnv allow` and open VS Code normally.

Notes about formatters
- This workspace enables `editor.formatOnSave`. Choose and configure one formatter in the Nix extension settings (nixpkgs-fmt or alejandra). Some formatters are external tools (not VS Code extensions) and require opening VS Code from the dev shell so they are available on PATH.

Removing old `nixfmt`
- If `nixfmt` still appears in your PATH due to a direnv/flake-profile, remove or regenerate the profile (see the repository instructions or run `rm -rf .direnv && direnv allow`), then clean up profiles with `nix profile` and run `nix-collect-garbage -d` when ready.
