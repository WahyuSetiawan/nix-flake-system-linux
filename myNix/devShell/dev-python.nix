{ inputs, system, pkgs, ... }:
let
  venvDir = "./env";
in
with pkgs ;mkShell {
  name = "Development Python";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.virtualenv
    python311Packages.setuptools
    python311Packages.wheel
  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
      echo "🚀 Python development shell ready!"

      # Buat virtualenv jika belum ada
      if [ ! -d "venv" ]; then
        python -m venv venv
      fi
    
      # Aktifkan virtualenv
      source venv/bin/activate
    
      # Install requirements jika file requirements.txt ada
      if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
      fi
    
      echo "Python development shell activated. Virtualenv tersedia di ./venv"
    '';
}
