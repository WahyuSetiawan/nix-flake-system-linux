{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services.nginx."nginx1" = {
    enable = true;
    httpConfig = ''
      server {
        listen 8888;  
        location / {
                add_header Content-Type text/plain;
                return 200 'Looks good';
            }
      }
    '';
  };


  services.phpfpm."phpfpm2" = {
    enable = true;
    listen = 9000;
    extraConfig = {
      "pm" = "ondemand";
      "pm.max_children" = 1;
    };
  };
}
