{ ... }: {
  cleanRust = ''
    # Bersihkan cache cargo
    cargo cache -a

    # Hapus target/debug dari proyek yang tidak aktif
    find ~ -name "target" -type d -prune -exec rm -rf '{}' +
  '';
}
