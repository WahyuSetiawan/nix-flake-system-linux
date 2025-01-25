{ config, pkgs, ... }:

{
  # Enable unfree packages (required for NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  # Load NVIDIA drivers in initrd
  boot.initrd.kernelModules = [ "nvidia" ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true; # Enable 32-bit support for Steam games
  };

  # Configure NVIDIA drivers
  hardware.nvidia = {
    # Use the latest proprietary driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable modesetting
    modesetting.enable = true;

    # Power management
    powerManagement = {
      enable = true;
      # finegrained = true;
    };

    # Prime configuration (if you have hybrid graphics)
    # prime = {
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };
    #   #   sync.enable = true;
    #   #
    #   #   # Uncomment and modify if you have hybrid graphics:
    #   #   # intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:10:0:0";
    #   amdgpuBusId = "PCI:30:0:0";
    #   #   reverseSync.enable = true; # Enable untuk switching GPU
    #   #   offload.enable = true; # Enable untuk mode offload
    # };
    #
    # Enable the NVIDIA settings menu
    nvidiaSettings = true;
  };

  # Configure X11
  services.xserver = {
    enable = true;

    # Configure display driver
    videoDrivers = [ "nvidia" ];

    # Configure hardware acceleration
    deviceSection = ''
      Option "UseEvents" "off"
    '';
  };

  # Install useful NVIDIA-related packages
  environment.systemPackages = with pkgs; [
    # NVIDIA utilities
    nvidia-vaapi-driver
    glxinfo
    vulkan-tools

    # Gaming-related (optional)
    steam-run
    lutris
  ];

  # Enable Vulkan support
  hardware.nvidia.nvidiaPersistenced = true;

  # Configure kernel parameters for better NVIDIA support
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # Enable kernel modesetting
  ];
}

