{ ... }: {

  cleanDocker = #bash 
    ''
      nix-shell -p docker --run "docker system prune"
    '';
}
