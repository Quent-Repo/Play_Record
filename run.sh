#/bin/sh
ffplay -i /dev/video3 -framerate 60 -video_size 640x360
ffmpeg -f x11grab -video_size 640x360 -framerate 10 -i :0.0799,511 -vf format=yuv420p test.mp4

v4l2-ctl --list-devices
r=wmctrl -l | grep -E -i '\/\w+' | cut -d' ' -f1
xwininfo -id $r