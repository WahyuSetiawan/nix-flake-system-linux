# Nix Flake System Configuration

Konfigurasi sistem Nix flake yang komprehensif untuk Linux dengan dukungan Home Manager dan development shells.

## 📁 Struktur Project

```
.
├── flake.nix                    # Entry point utama untuk Nix flake
├── flake.lock                   # Lock file untuk dependencies
├── myNix/                       # Konfigurasi Nix utama
│   ├── components/              # Komponen utility Nix
│   ├── cross-modules/           # Module lintas platform
│   ├── darwin-configurations/   # Konfigurasi untuk macOS
│   ├── darwin-modules/          # Module khusus macOS
│   ├── devShell/               # Development environments
│   ├── home-configurations/    # Konfigurasi Home Manager
│   ├── home-modules/           # Module Home Manager
│   ├── nixos-configurations/   # Konfigurasi NixOS
│   ├── nixos-modules/          # Module NixOS
│   ├── overlays/               # Nix overlays
│   └── services/               # Service definitions
├── dotfiles/                   # Dotfiles dan scripts instalasi
├── data/                       # Data aplikasi (MySQL, PostgreSQL, dll)
└── secrets/                    # File secrets terenkripsi
```

## 🚀 Quick Start

### Prerequisites

- Nix dengan flakes enabled
- Git

### Instalasi

1. Clone repository:
```bash
git clone <repository-url> ~/.nix
cd ~/.nix
```

2. Build konfigurasi sistem:
```bash
# Untuk NixOS
sudo nixos-rebuild switch --flake .#<hostname>

# Untuk Home Manager
nix run home-manager/master -- switch --flake .#<username>
```

3. Untuk development environment:
```bash
nix develop .#<environment-name>
```

## 🛠 Development Environments

Tersedia berbagai development shells yang sudah dikonfigurasi:

- **Laravel**: `nix develop .#dev-laravel`
- **Node.js**: `nix develop .#dev-nodejs` 
- **Python**: `nix develop .#dev-python`
- **React**: `nix develop .#dev-react`
- **Vue**: `nix develop .#dev-vue`
- **Rust**: `nix develop .#dev-rust`
- **Go**: `nix develop .#dev-go`
- **Flutter**: `nix develop .#dev-flutter`
- **Spring**: `nix develop .#dev-spring`
- **PHP**: `nix develop .#dev-php`

### Contoh Penggunaan

```bash
# Masuk ke development environment Laravel
nix develop .#dev-laravel

# atau dengan direnv (jika dikonfigurasi)
echo "use flake .#dev-laravel" > .envrc
direnv allow
```

## 🏠 Home Manager

Konfigurasi Home Manager untuk setup user environment:

### Pengguna yang Dikonfigurasi

- `juragankoding` - Konfigurasi untuk Linux
- `wahyu` - Konfigurasi untuk macOS

### Apply Home Manager

```bash
# Linux
home-manager switch --flake .#juragankoding

# macOS  
home-manager switch --flake .#wahyu
```

## 💻 NixOS Configuration

Konfigurasi sistem NixOS lengkap dengan:

- Package management
- Service configuration
- User management
- System settings

### Rebuild System

```bash
sudo nixos-rebuild switch --flake .
```

## 🍎 macOS (nix-darwin)

Dukungan untuk macOS menggunakan nix-darwin:

```bash
darwin-rebuild switch --flake .#wahyu
```

## 📦 Services & Data

### Layanan yang Dikonfigurasi

- **MySQL** - Database server dengan data di `data/mysql1/`
- **PostgreSQL** - Database server dengan data di `data/pg1/`
- **Redis** - In-memory data store di `data/redis-server/`
- **Nginx** - Web server dengan config di `data/nginx1/`
- **Open WebUI** - AI interface di `data/open-webui1/`
- **PHP-FPM** - PHP processor di `data/phpfpm2/`

### Management Data

Data services disimpan di direktori `data/` untuk persistensi:

```bash
# Backup data
tar -czf backup-$(date +%Y%m%d).tar.gz data/

# Restore data
tar -xzf backup-<date>.tar.gz
```

## 🔐 Secrets Management

Secrets dikelola menggunakan sops-nix atau agenix:

```bash
# Edit secrets
sops secrets/secrets.yaml
```

## 🔧 Customization

### Menambah Package Baru

Edit file yang sesuai di `myNix/home-modules/packages.nix` atau `myNix/nixos-modules/`:

```nix
# Contoh menambah package
environment.systemPackages = with pkgs; [
  # existing packages...
  new-package
];
```

### Development Environment Baru

Buat file baru di `myNix/devShell/`:

```nix
# myNix/devShell/dev-new-env.nix
{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # packages needed for development
  ];
  
  shellHook = ''
    echo "Welcome to new development environment!"
  '';
}
```

## 🏃‍♂️ Maintenance

### Update Flake Inputs

```bash
nix flake update
```

### Garbage Collection

```bash
# Clean old generations
nix-collect-garbage -d

# Clean old Home Manager generations
home-manager expire-generations "-7 days"
```

### Verify Configuration

```bash
# Check flake
nix flake check

# Build without switching
nixos-rebuild build --flake .
```

## 📝 Scripts & Utilities

### Dotfiles Management

Script di `dotfiles/` untuk:

- `install.sh` - Instalasi setup dasar
- `install_all_dependencies.sh` - Install semua dependencies
- `how_to_install_i3.sh` - Setup i3 window manager

### Instalasi Tambahan

```bash
# Install i3 window manager
./dotfiles/how_to_install_i3.sh

# Install semua dependencies
./dotfiles/install_all_dependencies.sh
```

## 🤝 Contributing

1. Fork repository
2. Buat branch baru: `git checkout -b feature/nama-fitur`
3. Commit perubahan: `git commit -am 'Add nama fitur'`
4. Push ke branch: `git push origin feature/nama-fitur`
5. Submit pull request

## 📄 License

[Tambahkan license yang sesuai]

## 🆘 Troubleshooting

### Common Issues

1. **Flake tidak bisa di-build**
   ```bash
   nix flake check --show-trace
   ```

2. **Home Manager error**
   ```bash
   home-manager switch --flake . --show-trace
   ```

3. **Service tidak jalan**
   ```bash
   systemctl status <service-name>
   journalctl -u <service-name>
   ```

### Logs

```bash
# System logs
journalctl -f

# Nix logs
nix log <derivation>
```

## 📞 Support

Jika ada pertanyaan atau issue, silakan:

1. Check [Issues](https://github.com/WahyuSetiawan/nix-flake-system-linux/issues)
2. Buat issue baru jika belum ada
3. Contact: [email/contact info]

---

**Note**: Konfigurasi ini dirancang untuk penggunaan personal dan development. Sesuaikan dengan kebutuhan Anda.