{ ... }:
{
  flake.overlays.macos =
    final: prev:
    let
      inherit (prev.lib) attrsets;
      callPackage = prev.newScope { };
      packages = [
        "xbar"
        # "obs-studio"
        "orbstack"
        "telegram"
        "iriun-webcam"
        "clipy"
        "sf-symbols"
        # "googlechrome" # see system/darwin/homebrew.nix
      ];
    in
    {
      # sbar_menus = prev.callPackage ../../nixosModules/darwin/sketchybar/helpers/menus { };
      # sbar_events = prev.callPackage ../../nixosModules/darwin/sketchybar/helpers/event_providers { };
      sbarLua = prev.callPackage ../../modules/conf-darwin/sketchybar/sbar.nix { };
      sketchybarConfigLua = prev.callPackage ../../modules/conf-darwin/sketchybar/config { };
      # sf-symbols-font = final.sf-symbols.overrideAttrs (old: {
      #   pname = "sf-symbols-font";
      #   installPhase = ''
      #     runHook preInstall 
      #
      #     mkdir -p $out/share/fonts
      #     cp -a Library/Fonts/* $out/share/fonts/
      #
      #     runHook postInstall
      #   '';
      #
      #   meta = old.meta // {
      #     description = "sf-symbols-font";
      #   };
      # });
    };
}

