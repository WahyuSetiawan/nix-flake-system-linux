{ ... }:
{
  flake.overlays.macos =
    final: prev:
    let
      inherit (prev.lib) attrsets;
      callPackage = prev.newScope { };
      packages = [
        # "xbar"
        # "obs-studio"
        # "orbstack"
        # "telegram"
        # "iriun-webcam"
        # "clipy"
        "sf-symbols"
        "vivaldi-dmg"
        "getworkfolio"
        "vivaldi-overlay"
        # "googlechrome" # see system/darwin/homebrew.nix
      ];
    in
    attrsets.genAttrs packages (name: callPackage ./${name}.nix { })
    // {
      sbar_menus = prev.callPackage ../../darwin-modules/sketchybar/helpers/menus { };
      sbar_events = prev.callPackage ../../darwin-modules/sketchybar/helpers/event_providers { };
      sbarLua = prev.callPackage ../../darwin-modules/sketchybar/helpers/sbar.nix { };
      sketchybarConfigLua = prev.callPackage ../../darwin-modules/sketchybar { };
      sf-symbols-font = final.sf-symbols.overrideAttrs (old: {
        pname = "sf-symbols-font";
        installPhase = ''
          runHook preInstall 

          mkdir -p $out/share/fonts
          cp -a Library/Fonts/* $out/share/fonts/

          runHook postInstall
        '';

        meta = old.meta // {
          description = "sf-symbols-font";
        };
      });
    };
}

