{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = false;
      })
      vivaldi-ffmpeg-codecs
      (opera.override { proprietaryCodecs = true; })
    ];
  };

  programs.firefox.enable = true;

}
