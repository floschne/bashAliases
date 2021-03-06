bash_prompt() {
    case $TERM in
     xterm*|rxvt*)
         local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac
    local NONE="\[\033[0m\]"    # unsets color to term's fg color
    
    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white
    
    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"
    
    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"
    
    local UC=$W                 # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color

    local BC=$EMK
    
#    PS1="$TITLEBAR${EMK}[${UC}\u@${UC}\h${EMK}:${EMW}\${NEW_PWD}${EMK}]${UC}${NONE} "
    # without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
# Display Prompt
#PS1="${cBorder}┌─(${White}\u@\h \$(date \"+%a, %d %b %y\")${cBorder})─\${fill}─(${cText}\$newPWD\
#${cBorder})────┐\n${cBorder}└─(${cText}\$(date \"+%H:%M\")${cBorder})─> ${White}"

    PS1="\n$TITLEBAR${BC}╓────┤ ${UC}\u@\h ${BC}├────┤ ${W}\${NEW_PWD} ${BC}├───\${fill}───┤ ${W}\$(date \"+%H:%M\") ${BC}│\n${BC}╙─▌${NONE}"
}

# Code for a cool Prompt
function fancy_pre_prompt
{
    # How many characters of the $PWD should be kept
    local pwdmaxlen=30
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi

    case $TERM in
     xterm*|rxvt*)
         local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac

    newPWD="${NEW_PWD}"
    user=`whoami`
    host=$(echo -n $HOSTNAME | sed -e "s/[\.].*//")
    datenow=$(date "+%a, %d %b %y")
    let promptsize=$(echo -n "-----| HH:MM |---| $user@$host |---| $newPWD |---" \
                 | wc -c | tr -d " ")

    width=$(tput cols)


    if [ `id -u` -eq 0 ]
    then
        let fillsize=${width}-${promptsize}+1
    else
        let fillsize=${width}-${promptsize}-1
    fi

    fill=""

    while [ "$fillsize" -gt "0" ]
    do
        fill="${fill}─"
        let fillsize=${fillsize}-1
    done

    if [ "$fillsize" -lt "0" ]
    then
        let cutt=3-${fillsize}
        newPWD="...$(echo -n $PWD | sed -e "s/\(^.\{$cutt\}\)\(.*\)/\2/")"
    fi
}

# Set prompt colour
if [ `id -u` -eq 0 ]
then
    cText="${LightRed}"
    cBorder="${Red}"
else
    cText="${LightCyan}"
    cBorder="${Cyan}"
fi

fancy_pre_prompt


PROMPT_COMMAND=fancy_pre_prompt
bash_prompt
unset bash_prompt


