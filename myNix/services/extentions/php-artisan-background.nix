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
    directoryWork = lib.mkOption {
      type = lib.types.string;
      default = "$PWD";
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
          command = #bash 
            ''
              echo "running on background at directory ${config.directoryWork}"
              ${config.package}/bin/php "${config.directoryWork}/artisan" queue:listen --queue=upload_image,upload_files --tries=${builtins.toString config.tries} --env="${config.directoryWork}/.env"
            '';

          readiness_probe =
            {
              exec.command = ''
                [ -e /tmp/laravel-worker-${name}.pid ]
              ''
              ;

              initial_delay_seconds = 2;
              period_seconds = 10;
              timeout_seconds = 4;
              success_threshold = 1;
              failure_threshold = 5;
            };

        };
      };
    };
  };
}
