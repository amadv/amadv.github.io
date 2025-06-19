# export LC_ALL=ja_JP.UTF-8
# export LC_CTYPE=ja_JP.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export GTK_IM_MODULE=uim
export XMODIFIERS=@im=uim

#xcalib -c && xcalib -red 1.15 1.2 45 -green 1.15 1.2 32 -blue 1.08 1 10 -a
#xcalib -red 1.15 1.2 88 -green 1.15 1.2 80 -blue 1.08 1 58 -a
xcalib -red 1.15 1.2 88 -green 1.15 1.2 76 -blue 1.08 1 48 -a

urxvtd -q -o -f

hsetroot -solid "#f0eedd"
xrdb ~/.dots/Xresources
xset s off
xset -dpms
picom --vsync &
/home/oui/.bin/bar &
xbanish &

urxvtc -g 64x30+443+80 -b 16 -e nvi .todo & 

exec cwm

