{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      # (vivaldi.overrideAttrs (old: {
      #   desktopItems = old.desktopItems ++ [
      #     (old.desktopItems [ 0 ] // {
      #       exec = "${old.desktopItems[0].exec} --ozone-platform=x11";
      #     })
      #   ];
      # }))
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = false;
      })
      vivaldi-ffmpeg-codecs
    ];
  };


  programs.firefox.enable = true;
}
