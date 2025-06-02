{ inputs, system, pkgs, ... }: with pkgs;mkShell {
  name = "rust-dev-shell";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    pkg-config
    openssl
  ];

  # Variabel environment
  RUST_BACKTRACE = "1";
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  # Shell hook (opsional)
  shellHook = ''
    echo "🚀 Rust development shell ready!"
    echo "Rustc: $(rustc --version)"
    echo "Cargo: $(cargo --version)"
  '';
}
