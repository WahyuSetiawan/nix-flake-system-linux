{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    home.user-info = {
      username = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      fullName = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      email = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      nixConfigDirectory = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      pathHome = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      within = {
        hyprland.enable = mkOption {
          type = with types; bool;
          default = false;
        };
        hyprland.theme = mkOption {
          type = types.enum [
            "mocha"
            "frappe"
            "macchiato"
            "latte"
          ];
          default = "mocha";
        };
        neovim.enable = mkOption {
          type = with types; bool;
          default = false;
        };
        gpg.enable = mkOption {
          type = with types; bool;
          default = false;
        };
        pass.enable = mkOption {
          type = with types; bool;
          default = false;
        };
      };
    };
  };
}
