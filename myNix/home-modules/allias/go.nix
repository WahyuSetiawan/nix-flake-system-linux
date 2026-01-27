{...}: {
  cleanGoBuild = #bash
    ''
      # Hapus cache Go module
      go clean -modcache

      # Hapus semua binary hasil build
      go clean -cache

      # Hapus direktori vendor jika ada
      find ~ -name "vendor" -type d -prune -exec rm -rf '{}' +

      # Hapus file binary Go di direktori bin
      find ~/go/bin -type f -executable -delete 2>/dev/null || true
    '';
}