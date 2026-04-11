# AI Services Configuration
#
# This module configures Ollama (LLM server) and Open WebUI (web interface) using process-compose.
#
# ## Platform Support:
# - macOS (aarch64-darwin): Uses CPU/Metal acceleration
# - Linux with NVIDIA GPU: Uses CUDA acceleration
# - Linux without NVIDIA: Falls back to CPU
#
# ## NVIDIA GPU Support (Linux):
# For CUDA acceleration to work, ensure:
# 1. NVIDIA drivers are installed and loaded (see: myNix/nixos-modules/hardware/nvidia.nix)
# 2. Verify GPU is detected: `nvidia-smi` or `ls /dev/nvidia*`
# 3. Verify CUDA is available: `nix run nixpkgs#cudatoolkit -- nvcc --version`
#
# ## Usage:
# - macOS: `nix run ~/.nix#ai --impure`
# - Linux: `nix run .#ai`
#
# ## GPU Configuration:
# Edit the CUDA_VISIBLE_DEVICES and OLLAMA_NUM_GPU variables below to configure
# which GPU(s) to use for inference.
#
{
  inputs,
  pc,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services =
    let
      dataDir = "$HOME/.process-compose/ai/data/ollamaX";
      # Detect NVIDIA GPU on Linux
      hasNvidia =
        pkgs.stdenv.isLinux
        && (builtins.pathExists "/dev/nvidia0" || builtins.pathExists "/sys/module/nvidia");
    in
    {
      ollama.ollamaX = {
        enable = true;
        # Use CUDA acceleration on Linux with NVIDIA GPU, null on macOS
        # Note: Requires NVIDIA drivers to be installed and configured on the system
        # See: myNix/nixos-modules/hardware/nvidia.nix for NVIDIA driver configuration
        acceleration = if pkgs.stdenv.isDarwin then null else "cuda";
        dataDir = dataDir;
        models = [
          "qwen2.5-coder"
          "deepseek-r1:1.5b"
        ];
        # Additional environment variables for NVIDIA GPU acceleration
        environmentVariables = lib.optionalAttrs (pkgs.stdenv.isLinux) {
          # Specify which GPU(s) to use (0-indexed)
          # Examples:
          # - "0" = use first GPU only
          # - "0,1" = use first and second GPU
          # - "1" = use second GPU only
          CUDA_VISIBLE_DEVICES = "0";

          # Number of GPUs Ollama should utilize
          # Should match the number of devices in CUDA_VISIBLE_DEVICES
          OLLAMA_NUM_GPU = "1";

          # Optional: Set GPU memory fraction (0.0 to 1.0)
          # Useful if you want to reserve GPU memory for other applications
          # OLLAMA_GPU_MEMORY_FRACTION = "0.8";

          # Optional: Force specific compute capability
          # CUDA_FORCE_PTX_JIT = "1";

          # Optional: Enable CUDA debugging (uncomment for troubleshooting)
          # CUDA_LAUNCH_BLOCKING = "1";
          # OLLAMA_DEBUG = "1";
        };
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
  settings.processes.open-webui1.depends_on.ollamaX-models.condition =
    "process_completed_successfully";

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
√√