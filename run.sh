#/bin/sh
#v4l2-ctl --list-devices

##Gets the cams and puts them into
f=1
cams_names=$(v4l2-ctl --list-devices | grep -E -i '.+:$')
cams_names_input=$(v4l2-ctl --list-devices | grep -E -i '/\w+/.+')
IFS=$'\n' read -rd '' -a y <<<"$cams_names"
cams_names_input_spliter=$'\n' read -rd '' -a x <<<"$cams_names_input"


echo 'Do you want to use: 
'
for i in "${y[@]}"
do
	echo "$i"
	for b in "${x[@]}"
	do
		if [ $(expr $f % 3) != 0 ]
		then
			echo $f. "$b"
			((f++))
		else
			((f++))
			echo $f. "$b"
			break
		fi
	done
done
echo 'Pick a number: '
read option
echo $option

r=wmctrl -l | grep -E -i '\/dev+\/\w+' | cut -d' ' -f1
xwininfo -id $r

ffplay -i /dev/video3 -framerate 60 -video_size 640x360
ffmpeg -f x11grab -video_size 640x360 -framerate 10 -i :0.0799,511 -vf format=yuv420p test.mp4

