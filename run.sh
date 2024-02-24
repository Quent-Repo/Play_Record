#/bin/sh
#v4l2-ctl --list-devices

##Gets the cams and puts them into
f=1
cams_names=$(v4l2-ctl --list-devices | grep -E -i '.+:$')
cams_names_input=$(v4l2-ctl --list-devices | grep -E -i '/\w+/.+')
IFS=$'\n' read -rd '' -a y <<<"$cams_names"
cams_names_input_spliter=$'\n' read -rd '' -a x <<<"$cams_names_input"


echo 'Which would you like to use: 
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
			echo $f. "$b"
			((f++))
			break
		fi
	done
done
echo 'Pick a number: '
read option
echo ${x[$option-1]}

## Opens new term to run ffplay. (Thing to note here is that *roxterm* need to to changed to what every term is running on device i.e gnome-terminal -e, xterm -e, konsole -e)
## could do some kind of error handle and use a list to see which one will work or use ``` ps -aux | grep `ps -p $$ -o ppid=` ``` to get the terminal name
roxterm -e ffplay -i ${x[$option-1]} -framerate 60 -video_size 640x360  ; sleep 2


##Gets all the information on the ffplay video
r=$(wmctrl -l | grep -E -i '\/dev+\/\w+' | cut -d' ' -f1)
xwininfo -id $r

x_value=$(xwininfo -id $r | grep 'Absolute upper-left X')
y_value=$(xwininfo -id $r | grep 'Absolute upper-left Y')

##The numbers for the Absolute upper X and Y
last_x=$(echo $x_value | grep -Eo '[0-9]{1,4}')
last_y=$(echo $y_value | grep -Eo '[0-9]{1,4}')

date_name=$(date +"%Y-%m-%d-%H.%M.%S")

echo "---------------------------------------------------"

##Record The ffplay
ffmpeg -f x11grab -video_size 640x360 -framerate 10 -i :0.0+$last_x,$last_y -vf format=yuv420p $date_name.mp4
