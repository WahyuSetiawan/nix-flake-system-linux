{ inputs, ... }: {
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services.redis.redis-server = {
    enable = true;
  };
}
