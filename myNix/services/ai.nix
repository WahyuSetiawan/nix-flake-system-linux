{ inputs, pc, lib, pkgs, ... }: {
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services = let dataDir = "$HOME/.process-compose/ai/data/ollamaX"; in
    {
      ollama.ollamaX =
        {
          enable = true;
          # acceleration = "cuda";
          dataDir = dataDir;
          models = [
            "qwen2.5-coder"
            "deepseek-r1:1.5b"
          ];
        };

      open-webui."open-webui1" = {
        enable = true;
        dataDir = "${dataDir}/open-webui";
        environment =
          let
            inherit (pc.config.services.ollama.ollamaX) host port;
          in
          {
            OLLAMA_API_BASE_URL = "http://${host}:${toString port}/api";
            WEBUI_AUTH = "False";
            # Not required since `WEBUI_AUTH=False`
            WEBUI_SECRET_KEY = "";
            # If `RAG_EMBEDDING_ENGINE != "ollama"` Open WebUI will use
            # [sentence-transformers](https://pypi.org/project/sentence-transformers/) to fetch the embedding models,
            # which would require `DEVICE_TYPE` to choose the device that performs the embedding.
            # If we rely on ollama instead, we can make use of [already documented configuration to use GPU acceleration](https://community.flake.parts/services-flake/ollama#acceleration).
            RAG_EMBEDDING_ENGINE = "ollama";
            RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
            # RAG_EMBEDDING_MODEL_AUTO_UPDATE = "True";
            # RAG_RERANKING_MODEL_AUTO_UPDATE = "True";
            # DEVICE_TYPE = "cpu";
          };
      };
    };

  # Start the Open WebUI service after the Ollama service has finished initializing and loading the models
  settings.processes.open-webui1.depends_on.ollamaX-models.condition = "process_completed_successfully";

  settings.processes.open-browser = {
    command =
      let
        inherit (pc.config.services.open-webui.open-webui1) host port;
        opener = if pkgs.stdenv.isDarwin then "open" else lib.getExe' pkgs.xdg-utils "xdg-open";
        url = "http://${host}:${toString port}";
      in
      "${opener} ${url}";
    depends_on.open-webui1.condition = "process_healthy";
  };

}
