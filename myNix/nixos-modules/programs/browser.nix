{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      # (vivaldi.override {
      #   proprietaryCodecs = true;
      #   enableWidevine = false;
      # })
      # vivaldi-ffmpeg-codecs
    ];
  };


  programs.firefox.enable = true;
}
