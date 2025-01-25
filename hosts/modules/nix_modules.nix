{ ... }: {
  flake.commonModules = {
    system-shell = import ./shells.nix;
  };

  flake.darwinModules = [

  ];


  flake.linuxModules = [ ];


}
