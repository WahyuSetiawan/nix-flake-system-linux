{ ... }: {
   home.file.".config/sketchybar/sketchybarrc".text = ''
    # Atur warna dan tinggi bar
    sketchybar --bar height=30 color=0xff2e3440

    # Tambahkan item ke bar
    sketchybar --add item clock right
    sketchybar --set clock icon="🕒" label="$(date +'%H:%M')"

    sketchybar --add item battery right
    sketchybar --set battery icon="🔋" label="$(pmset -g batt | grep -o '[0-9]\+%')"

    sketchybar --add item spacer left
    sketchybar --set spacer width=10

    sketchybar --add item cpu left
    sketchybar --set cpu icon="💻" label="$(top -l 1 | grep 'CPU usage' | awk '{print $3}')"

    sketchybar --add item memory left
    sketchybar --set memory icon="🧠" label="$(top -l 1 | grep 'PhysMem' | awk '{print $2}')"
  '';
}
