#!/bin/bash
mount_path=$(echo $2 | sed "s/\['\|'\]//g")

# only react to mount actions
if [ "$1" = "device_mounted" ];then
    echo "Log start at: $(date +'%F-%H-%M-%S')"
    set -o xtrace
    pkill mpv

    #find all video files in mount_path
    filelist=$(sudo find "$mount_path"/* -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p')

    #find latest in filelist
    unset -v latest
    for file in $filelist; do
      [[ $file -nt $latest ]] && latest=$file
    done

    #run latest if filetype is video
    # zenity --info --timeout=10 --text "newest file in $2: $latest"
    if [[ $(file --mime-type $latest | cut -d ":" -f2 | sed "s/\s//g") == "video"* ]]; then
        mpv --fs $latest > /dev/null 2>&1
    else
        zenity --error --text "the newest file is not a video!" --timeout 10
    fi
fi
