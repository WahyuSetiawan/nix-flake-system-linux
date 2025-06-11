{ ... }: {
  cleanPythonPip = #bash 
    ''
      # Hapus cache pip
      nix-shell -p python313Packages.pip --run "pip cache purge"

      # Hapus __pycache__ dan .pyc
      find ~ -name "__pycache__" -type d -prune -exec rm -rf '{}' +
      find ~ -name "*.pyc" -delete
    '';
}
