{ inputs, ... }: {
  perSystem = { lib, system, input', pkgs, config, ... }: {
    process-compose = {
      ai = pc: import ./ai.nix {
        inherit pc lib pkgs inputs;
      };

      mysql = pc: import ./mysql.nix {
        inherit pc lib pkgs inputs config;
      };

      postgres = pc: import ./postgres.nix {
        inherit pc lib pkgs inputs config;
      };
    };
  };
}
