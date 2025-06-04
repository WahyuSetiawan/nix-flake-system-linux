{ ... }: {
  cleanNpm = ''
    # Bersihkan cache npm/yarn
        npm cache clean --force
        yarn cache clean

    # Hapus node_modules yang tidak perlu
        find ~ -name "node_modules" -type d -prune -exec rm -rf '{}' +

    # Hapus .npm/_logs (log error npm)
        rm -rf ~/.npm/_logs
  '';


}
