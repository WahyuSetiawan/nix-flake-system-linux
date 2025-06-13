{ config
, lib
, name
, pkgs
, ...
}:
let
  inherit (lib) types;
in
{
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
    };
    tries = lib.mkOption {
      type = lib.types.int;
      default = 3;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.php82;
      defaultText = "pkgs.php82";
    };
  };


  config = {
    outputs = {
      settings.processes = {
        ${name} = {
          command = "${config.package}/bin/php artisan queue:work --tries=${builtins.toString config.tries}";
        };
      };
    };
  };
}
