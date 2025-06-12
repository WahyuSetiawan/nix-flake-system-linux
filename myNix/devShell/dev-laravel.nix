{ inputs, config, system, pkgs, ... }:
with pkgs;
mkShell {
  inputsFrom = [
    config.process-compose."nginx".services.outputs.devShell
  ];

  name = "laravel-dev-shell";

  # Daftar paket yang diperlukan
  buildInputs = with pkgs; [
    # PHP dan ekstensi yang diperlukan
    php83
    php83Packages.composer
    php83Extensions.curl
    php83Extensions.mbstring
    php83Extensions.xml
    php83Extensions.openssl
    php83Extensions.pdo
    php83Extensions.pdo_mysql
    php83Extensions.tokenizer
    php83Extensions.ctype
    # php83Extensions.json
    php83Extensions.bcmath

    # Node.js dan npm (untuk frontend build tools seperti Vite)
    nodejs_20

    # Database (opsional, pilih salah satu)
    mysql80
    # postgresql_15

    # Alat bantu development
    git
    curl
    unzip
  ];

  # Variabel lingkungan
  shellHook = ''
    echo "Laravel development shell ready!"
    echo "PHP: $(php --version | head -n 1)"
    echo "Composer: $(composer --version)"
    echo "Node.js: $(node --version)"
    echo "npm: $(npm --version)"
  '';
}
