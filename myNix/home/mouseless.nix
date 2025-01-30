{ ... }: {
  home.file.".config/sketchybar/sketchybarrc".text = ''
    # Sketchybar configuration
    sketchybar --bar height=30 color=0xff2e3440

    # Add items to the bar
    sketchybar --add item clock right
    sketchybar --set clock icon="🕒" label="$(date +'%H:%M')"
    sketchybar --add item battery right
    sketchybar --set battery icon="🔋" label="$(pmset -g batt | grep -o '[0-9]\+%')"
  '';
}
