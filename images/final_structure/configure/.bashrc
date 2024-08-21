# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


[[ $- != *i* ]] && return

# ------------------
# SET PATH
# ------------------

function _path_add_tool_bin() {
    tool_name=$1
    for d in "$TOOLS/$tool_name"/*/ ; do
        if [ -d "${d}bin" ]; then
            export PATH=$PATH:${d}bin
        fi
    done
}

function _path_add_tool() {
    tool_name=$1
    for d in "$TOOLS/$tool_name"/*/ ; do
        if [ -d "${d}" ]; then
            export PATH=$PATH:${d%/}
        fi
    done
}

function _path_add_tool_custom() {
    custom_path=$1
    for d in $TOOLS/$custom_path/ ; do
        if [ -d "${d}" ]; then
            export PATH=$PATH:${d%/}
        fi
    done
}

function _path_add_tool_python() {
    tool_name=$1
    for d in "$TOOLS/$tool_name"/*/local/lib/python3*/dist-packages ; do
        if [ -d "${d}" ]; then
            export PYTHONPATH=$PYTHONPATH:${d}
        fi
    done
}

# _path_add_tool_bin      "covered"
_path_add_tool_bin      "cvc_rv"
# _path_add_tool_bin      "gaw3-xschem"
# _path_add_tool_bin      "gds3d"
# _path_add_tool_bin      "ghdl"
# _path_add_tool_bin      "gtkwave"
# _path_add_tool_bin      "irsim"
# _path_add_tool_bin      "iverilog"
# _path_add_tool          "klayout"
# _path_add_tool_custom   "libman"
_path_add_tool_bin      "magic"
_path_add_tool_bin      "netgen"
_path_add_tool_bin      "ngspice"
# _path_add_tool_bin      "nvc"
_path_add_tool_bin      "openroad"
# _path_add_tool_bin      "opensta"
_path_add_tool_bin	    "openvaf"
# _path_add_tool_custom   "osic-multitool"
# _path_add_tool_bin      "padring"
# _path_add_tool_bin      "pyopus"
# _path_add_tool_bin      "qflow"
# _path_add_tool_bin      "qucs-s"
# _path_add_tool_custom   "rftoolkit/bin"
# _path_add_tool_bin      "slang"
# _path_add_tool_bin      "verilator"
_path_add_tool_bin      "xschem"
# _path_add_tool_bin      "xyce/Parallel"
_path_add_tool_bin      "yosys"
_path_add_tool_custom   "yosys/bin"


# ------------------
# SET PDK PARAMETERS
# ------------------

set_pdk () {
    PDK=$1
    case "$PDK" in
    gf180mcuC) echo "gf180mcuC is not supported, only D variant" ;;
    gf180mcuD) export STD_CELL_LIBRARY=gf180mcu_fd_sc_mcu7t5v0 ;;
    sky130A)   export STD_CELL_LIBRARY=sky130_fd_sc_hd ;;
    ihp-sg13g2)    export STD_CELL_LIBRARY=sg13g2_stdcell ;;
    *)         echo "PDK $PDK NOT RECOGNIZED" && return ;;
    esac

    IHP_OPENVAF_DIR=$PDK_ROOT/ihp-sg13g2/libs.tech/ngspice/openvaf
    if [ ! -f "$IHP_OPENVAF_DIR/psp103_nqs.osdi" ]; then
        echo "Compiling ihp-sg13g2 osdi files"
        openvaf $IHP_OPENVAF_DIR/psp103_nqs.va --output /tmp/psp103_nqs.osdi

        if [ $? -eq 0 ]; then
            echo "Compilation succeded"
            sudo mv /tmp/psp103_nqs.osdi $IHP_OPENVAF_DIR
        else
            echo "Compilation failed, reopen another terminal"
        fi
    fi

    export PDK=$PDK
    export PDKPATH=$PDK_ROOT/$PDK

    export SPICE_USERINIT_DIR=$PDK_ROOT/$PDK/libs.tech/ngspice

    export KLAYOUT_HOME=$PDK_ROOT/$PDK/libs.tech/klayout
    export KLAYOUT_PATH=$KLAYOUT_HOME:$(realpath $TOOLS/klayout/download)

    alias xschem='xschem --rcfile $PDK_ROOT/$PDK/libs.tech/xschem/xschemrc'
    alias xschemtcl='xschem --rcfile $PDK_ROOT/$PDK/libs.tech/xschem/xschemrc'
    alias magic='magic -rcfile $PDK_ROOT/$PDK/libs.tech/magic/*.magicrc'

}

if [ "$PDK" == "" ]; then
    echo "PDK not defined, using default one"
    set_pdk sky130A
else
    set_pdk $PDK
fi


# ------------------
# SET PROMPT
# ------------------

function git_branch {
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ "$branch" != "" ]; then
      echo "[$branch]"
    fi
}

c_res='\[\033[00m\]'      # Reset
c_bla='\[\033[01;30m\]'   # Black
c_red='\[\033[01;31m\]'   # Red
c_gre='\[\033[01;32m\]'   # Green
c_yel='\[\033[01;33m\]'   # Yellow
c_blu='\[\033[01;34m\]'   # Blue
c_pur='\[\033[01;35m\]'   # Purple
c_cya='\[\033[01;36m\]'   # Cyan
c_whi='\[\033[01;37m\]'   # White

# export PS1="${c_pur}\w $(git_branch)\n${c_res}\$ " ## This dont work :(
PS1="${c_cya}\u ${c_pur}\w \n${c_res}\$ " ## This dont work :(
    

# --------------------------------
# USEFUL ENV VARIABLES AND ALIASES
# --------------------------------

alias ls="ls --color=auto -XF"
alias grep="grep --color=auto"
