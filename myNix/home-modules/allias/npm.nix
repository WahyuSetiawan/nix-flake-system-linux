{ ... }: {
  cleanNpm = #bash 
    ''
      # Bersihkan cache npm/yarn
      nix-shell -p nodejs_20 --run "npm cache clean --force"
      nix-shell -p yarn --run "yarn cache clean"
      nix-shell -p pnpm --run "pnpm cache delete"

      # Hapus node_modules yang tidak perlu
      find ~ -name "node_modules" -type d -prune -exec rm -rf '{}' +

      # Hapus .npm/_logs (log error npm)
      rm -rf ~/.npm/_logs
    '';
  mkVue = #bash
    ''
      nix-shell -p nodejs_20 --run "npm create vue@latest"
    '';
  mkNextJs = #bash
    ''
      nix-shell -p nodejs_20 --run "npx create-next-app@latest"
    '';
  mkNodeJs = #bash
    ''
      nix-shell -p nodejs_20 --run "npx express-generator"
    '';
  mkNuxtJs = #bash
    ''
      nix-shell -p nodejs_20 --run "npm create nuxt "
    '';
  mkAstro = #bash
    ''
      nix-shell -p nodejs_20 --run "npm create astro@latest"
    '';
}
