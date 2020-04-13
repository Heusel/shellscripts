#!/bin/bash
mount_path=$(echo $2 | sed "s/\['\|'\]//g")

# only react to mount actions
if [ "$1" = "device_mounted" ];then
    echo "Log start at: $(date +'%F-%H-%M-%S')"
    set -o xtrace
    pkill mpv
    # only play the newest file
    unset -v latest
    for file in "$mount_path"/*; do
        [[ $file -nt $latest ]] && latest=$file
    done
    # zenity --info --timeout=10 --text "newest file in $2: $latest"
    if [[ $(file --mime-type $latest | cut -d ":" -f2 | sed "s/\s//g") == "video"* ]]; then
        mpv --fs $latest > /dev/null 2>&1
    else
	zenity --error --text "the newest file is not a video!" --timeout 10
    fi
fi
