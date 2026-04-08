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
    openssl.dev
    # rustls-libssl
  ];
  # Variabel environment
  RUST_BACKTRACE = "1";
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  OPENSSL_DIR = "${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = true;
  
  # Shell hook (opsional)
  shellHook = ''
    echo "🚀 Rust development shell ready!"
    echo "Rustc: $(rustc --version)"
    echo "Cargo: $(cargo --version)"
  '';
}
