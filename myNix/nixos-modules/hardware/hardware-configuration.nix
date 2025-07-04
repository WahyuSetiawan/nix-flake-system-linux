# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/bcca4bb5-5483-4531-bad9-bd1d8d2821b7";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4F41-A0BE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/ssd" =
    {
      device = "/dev/disk/by-uuid/01D9242F1B1564B0";
      fsType = "ntfs";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
        "locale=en_US.utf8"
        "permissions"
        "uid=1000" # Ganti dengan UID user Anda (juragankoding)
        "gid=1000" # Ganti dengan GID group Anda (juragankoding)
        "fmask=002" # Permission untuk file: rw-r--r-- (644)
        "dmask=002" # Permission untuk folder: rwxr-xr-x (755)
      ];
    };

  fileSystems."/mnt/data" =
    {
      device = "/dev/disk/by-uuid/3EE2CD3DE2CCF9E3";
      fsType = "ntfs";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
        "locale=en_US.utf8"
        "permissions"
        "uid=1000" # Ganti dengan UID user Anda (juragankoding)
        "gid=1000" # Ganti dengan GID group Anda (juragankoding)
        "fmask=002" # Permission untuk file: rw-r--r-- (644)
        "dmask=002" # Permission untuk folder: rwxr-xr-x (755)
      ];
    };


  fileSystems."/mnt/entertaiments" =
    {
      device = "/dev/disk/by-uuid/D0A65A0FA659F686";
      fsType = "ntfs";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
        "permissions"
        "locale=en_US.utf8"
        "uid=1000" # Ganti dengan UID user Anda (juragankoding)
        "gid=1000" # Ganti dengan GID group Anda (juragankoding)
        "fmask=002" # Permission untuk file: rw-r--r-- (644)
        "dmask=002" # Permission untuk folder: rwxr-xr-x (755)
      ];
    };


  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/e8139a51-7575-4480-a29e-1ba0fe14326f";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/d0e9a1b7-2205-455a-9ef3-36a65f81e134"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp41s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
