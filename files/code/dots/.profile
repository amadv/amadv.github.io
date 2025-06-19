ulimit -c 0

export HISTFILE=/tmp/hist
export HISTSIZE=500
export LESSHISTFILE=/dev/null
export NNN_PLUG='g:-!grid*'
export EDITOR=vi
export LESS='-~ -c -Q -Ps'
export EXINIT="set tabstop=4|set shiftwidth=4|set noflash"

#export EDITOR='rlwrap -A! ed -s'
#export LESSEDIT='%E -s %f'
export PAGER=less


PATH=$HOME/.bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R7/bin:/usr/pkg/bin
PATH=${PATH}:/usr/pkg/sbin:/usr/games:/usr/local/bin:/usr/local/sbin
export PATH

export ENV=$HOME/.shrc

