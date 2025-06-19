export LC_ALL=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export GTK_IM_MODULE=uim
export XMODIFIERS=@im=uim

xrdb ~/.dots/Xresources
xset fp+ /usr/X11R6/lib/X11/fonts/custom
xset fp+ /usr/local/share/fonts/terminus
xset fp rehash
xset s off
xset -dpms
urxvtd -q -o -f
picom --vsync &

ulimit -Sc 0

redshift -P -O 4500

hsetroot -solid "#f0ddb2"
/home/oui/.bin/bar &
xbanish &

urxvtc -g 64x34+678+181 -b 18 -e vi .todo & 

doas /home/oui/.bin/httpd &

exec cwm

