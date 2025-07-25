{ config
, lib
, name
, pkgs
, ...
}:
let
  inherit (lib) types;

  toStr =
    value:
    if true == value then
      "yes"
    else if false == value then
      "no"
    else
      toString value;

  configType =
    with types;
    attrsOf (oneOf [
      str
      int
      bool
    ]);
in
{
  options = {
    package = lib.mkPackageOption pkgs "php" { };

    listen = lib.mkOption {
      type = types.either types.port types.str;
      default = "phpfpm.sock";
      description = ''
        The address on which to accept FastCGI requests.
      '';
    };

    phpOptions = lib.mkOption {
      type = types.lines;
      default = "";
      example = ''
        date.timezone = "CET"
      '';
      description = ''
        Options appended to the PHP configuration file {file}`php.ini` used for this PHP-FPM pool.
      '';
    };

    phpEnv = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Environment variables used for this PHP-FPM pool.
      '';
      example = lib.literalExpression ''
        {
          HOSTNAME = "$HOSTNAME";
          TMP = "/tmp";
          TMPDIR = "/tmp";
          TEMP = "/tmp";
        }
      '';
    };

    extraConfig = lib.mkOption {
      type = configType;
      default = { };
      description = ''
        PHP-FPM pool directives. Refer to the "List of pool directives" section of
        <https://www.php.net/manual/en/install.fpm.configuration.php>
        for details. Note that settings names must be enclosed in quotes (e.g.
        `"pm.max_children"` instead of `pm.max_children`).
      '';
      example = lib.literalExpression ''
        {
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
        }
      '';
    };
  };
  config = {
    extraConfig.listen = lib.mkDefault config.listen;

    outputs.settings = {
      processes.${name} =
        let
          log = if pkgs.stdenv.isDarwin then "/dev/stderr" else "/proc/self/fd/2";
          cfgFile = pkgs.writeText "phpfpm-${name}.conf" ''
            [global]
            pid = /tmp/php-fpm-${name}.pid
            daemonize = no
            error_log = ${log}

            [${name}]
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n} = ${toStr v}") config.extraConfig)}
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "env[${n}] = ${toStr v}") config.phpEnv)}
          '';
          iniFile =
            pkgs.runCommand "php.ini"
              {
                inherit (config) phpOptions;
                preferLocalBuild = true;
                passAsFile = [ "phpOptions" ];
              }
              ''
                cat ${config.package}/etc/php.ini $phpOptionsPath > $out
              '';
        in
        {
          command = pkgs.writeShellApplication {
            name = "start-phpfpm";
            runtimeInputs = [ config.package ];
            text = ''
              DATA_DIR="$(readlink -m ${config.dataDir})"
              if [[ ! -d "$DATA_DIR" ]]; then
                mkdir -p "$DATA_DIR"
              fi
              exec php-fpm  -F -p "$DATA_DIR" -y ${cfgFile} 
            '';
          };

          readiness_probe =
            {
              exec.command = ''
                [ -e /tmp/php-fpm-${name}.pid ]
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
}
