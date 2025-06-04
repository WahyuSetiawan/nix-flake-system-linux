{ ... }: {
  cleanAndroidGradle = ''
    # Hapus cache Gradle
    rm -rf ~/.gradle/caches/

    # Hapus build Android yang menumpuk
    find ~ -name "build" -type d -prune -exec rm -rf '{}' +
  '';

}
