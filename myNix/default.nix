{ self
, lib
, inputs
, ...
}: {
  imports = [
    ./modules
    ./home
    ./hosts
    ./overlays
    ./devShell.nix
  ];

  perSystem = { lib, system, input', ... }:
    {
      process-compose."ai" = {
        imports = [
          inputs.services-flake.processComposeModules.default
        ];
        services.ollama.ollamaX = let dataDir = "$HOME/.process-compose/ai/data/ollamaX"; in
          {
            enable = true;
            dataDir = dataDir;
            models = [
              "qwen2.5-coder"
              "deepseek-r1:1.5b"
            ];
            # open-webui.enable = true;
          };
      };

      _module.args =
        let
          selfOverlays = lib.attrValues self.overlays;
          overlays = [ ] ++ selfOverlays;
        in
        rec {
          nix = {
            gc = {
              automatic = true;
              options = "--delete-older-than 7d";
            };
          };

          nixpkgs = {
            config = {
              lib.mkForce = {
                allowBroken = true;
                allowUnfree = true;
                tarball-ttl = 0;

                contentAddressedByDefault = false;
              };
            };

            hostPlatform = system;
            inherit overlays;
          };

          pkgs = import inputs.nixpkgs {
            inherit system;
            inherit (nixpkgs) config;
            inherit overlays;
          };

          basePackageFor = pkgs: builtins.attrValues {
            inherit (pkgs)
              vim curl
              neovim
              wget
              git
              ;
          };
        };
    };
}
