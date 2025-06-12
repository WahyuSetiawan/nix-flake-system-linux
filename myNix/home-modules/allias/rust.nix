{ ... }: {
  cleanRust = #bash
    ''
    # Bersihkan cache cargo
    nix-shell -p cargo cargo-cache --run "cargo cache -a"

    # Hapus target/debug dari proyek yang tidak aktif
    find ~ -name "target" -type d -prune -exec rm -rf '{}' +
  '';
}
