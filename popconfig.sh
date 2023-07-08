#!/bin/bash

# user variables
ssh_port="4242" #change port 22 for SSH to alternative
ssh_pub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxPQteXvxJFskR1IVkkA8x9Fav1rUMLWdffSAbJnhiz theverbaldotnet" #ssh public key ed25519

# declare variables
acct=$(/usr/bin/logname) #captures the name of the user running the script instead of root when run as sudo
progname=$0 #captures the name of the program for logging
logfile=/var/log/popconfig.log
errorlog=/var/log/popconfig_errors.log
hosts=/etc/hosts

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  /usr/bin/echo "You must be a root user to run this script, please run sudo debianconfig" 2>&1
  exit 1
fi

# update repositories
/usr/bin/apt update 1>>$logfile 2>>$errorlog && /usr/bin/apt upgrade -y 1>>$logfile 2>>$errorlog

# install nala - apt front-end
/usr/bin/apt install nala -y 1>>$logfile 2>>$errorlog

# install additional packages
/usr/bin/nala install -y tilix fish vim pavucontrol steam gimp qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils bpytop caffeine vlc neofetch bat exa ripgrep tldr resolvconf powerline autojump samba gimp flameshot thunderbird 1>>$logfile 2>>$errorlog

flatpak install -y bitwarden obsidian notepadqq steam webcord onlyoffice zotero signal

# configure alias file
cat <<EOF > /home/$acct/.config/fish/alias.fish
# # # # # # # # # # # # # # # # # # # #
#  █████╗ ██╗     ██╗ █████╗ ███████╗ #
# ██╔══██╗██║     ██║██╔══██╗██╔════╝ #
# ███████║██║     ██║███████║███████╗ #
# ██╔══██║██║     ██║██╔══██║╚════██║ #
# ██║  ██║███████╗██║██║  ██║███████║ #
# ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝ #
# # # # # # # # # # # # # # # # # # # #


# ls with exa and flags
alias ls="exa -al --color=always --group-directories-first"

# cat with bat(cat)
alias cat=batcat

# replace grep with ripgrep
alias grep=rg

# vim
alias vi=vim
alias svi="sudo vi"
alias edit=vim

# cd up the directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# shortcuts
alias h=history
alias c=clear
alias f='find . |grep '

# get disk free space formatted
alias df="sudo df -Tha --total"

# get memory usage
alias free="free -mt"

# mkdir create parents
alias mkdir="mkdir -pv"

# sudo for systemctl commands
alias systemctl="sudo systemctl"

# get external IP address
alias myip="curl http://ipecho.net/plain; echo"

# display disk devices in order
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"

# automatically resume a download if it is interrupted
alias wget='wget -c'

# show progress bar when copying files
alias cpv='rsync -ah --info=progress2'

### NETWORKING ###
alias evpn='expressvpn connect'
alias evpnd='expressvpn disconnect'
# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'
alias flushdns='sudo resolvectl flush-caches'

# power
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown now'

# nala package manager
alias update='sudo nala update && sudo nala upgrade && flatpak update'
alias upd='sudo nala update'
alias upg='sudo nala upgrade'
alias install='sudo nala install'
alias remove='sudo nala remove'

# datetime
alias d='date +%F'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%m-%d-%Y"'

# confirmation for file commands
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'

# virtualization
alias woolong="virsh start woolong"
alias pause="virsh suspend"
alias resume="virsh resume"
alias rview="remote-viewer spice://127.0.0.1:5900"

# programs
alias pycharm='sh /opt/pycharm-community-2022.2.3/bin/pycharm.sh'
EOF

# Configure SSH for Port $ssh_port and disable root login
/usr/bin/cp --archive $sshf $sshf-COPY-$(/usr/bin/date +"%Y%m%d%H%M%S") 1>>$logfile 2>>$errorlog
/usr/bin/sed -i "s/#Port 22/Port $ssh_port/" $sshf 1>>$logfile 2>>$errorlog
/usr/bin/sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/" $sshf 1>>$logfile 2>>$errorlog
/usr/bin/mkdir /home/$acct/.ssh 1>>$logfile 2>>$errorlog
/usr/bin/touch /home/$acct/.ssh/authorized_keys 1>>$logfile 2>>$errorlog
/usr/bin/chmod 600 /home/$acct/.ssh/authorized_keys 1>>$logfile 2>>$errorlog
/usr/bin/echo -e "$ssh_pub" >> /home/$acct/.ssh/authorized_keys 1>>$logfile 2>>$errorlog
/usr/bin/systemctl restart sshd 1>>$logfile 2>>$errorlog

# Configure HOSTS file
/usr/bin/cp --archive $hosts $hosts-COPY-$(/usr/bin/date +"%Y%m%d%H%M%S") 1>>$logfile 2>>$errorlog
/usr/bin/rm $hosts
/usr/bin/touch $hosts
cat <<EOF > $hosts
# IPv4
127.0.0.1	localhost
127.0.1.1	pop-os.localdomain     pop-os
127.1.1.1	ed # this is the name of the computer

# IPv6
::1          localhost
EOF

# create fish config
/usr/bin/cat <<EOF > /home/$acct/.config/fish/config.fish
# # # # # # # # # # # # # # # # # # # # # # # # # # #
# ██╗   ██╗███████╗██████╗ ██████╗  █████╗ ██╗      #
# ██║   ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗██║      #
# ██║   ██║█████╗  ██████╔╝██████╔╝███████║██║      #
# ╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══██╗██╔══██║██║      #
#  ╚████╔╝ ███████╗██║  ██║██████╔╝██║  ██║███████╗ #
#   ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝ #
# # # # # # # # # # # # # # # # # # # # # # # # # # #

# My fish config.
set -U fish_user_paths $fish_user_paths $HOME/.local/bin/
set fish_greeting                       # Suppress fish intro message
set TERM "xterm-256color"               # Set terminal type
set EDITOR vim                          # $EDITOR use vim in terminal

# set vim keybinds
fish_vi_key_bindings

# Aliases
if [ -f $HOME/.config/fish/alias.fish ]
source $HOME/.config/fish/alias.fish
end

# activate Powerline
set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
source /usr/share/powerline/bindings/fish/powerline-setup.fish
powerline-setup

# activate autojump
set -gx AUTOJUMP_SOURCED 1

# set user installation path
if test -d ~/.autojump
    set -x PATH ~/.autojump/bin $PATH
end

# Set ostype, if not set
if not set -q OSTYPE
    set -gx OSTYPE (bash -c 'echo ${OSTYPE}')
end


# enable tab completion
complete -x -c j -a '(autojump --complete (commandline -t))'


# set error file location
if test (uname) = "Darwin"
    set -gx AUTOJUMP_ERROR_PATH ~/Library/autojump/errors.log
else if test -d "$XDG_DATA_HOME"
    set -gx AUTOJUMP_ERROR_PATH $XDG_DATA_HOME/autojump/errors.log
else
    set -gx AUTOJUMP_ERROR_PATH ~/.local/share/autojump/errors.log
end

if test ! -d (dirname $AUTOJUMP_ERROR_PATH)
    mkdir -p (dirname $AUTOJUMP_ERROR_PATH)
end


# change pwd hook
function __aj_add --on-variable PWD
    status --is-command-substitution; and return
    autojump --add (pwd) >/dev/null 2>>$AUTOJUMP_ERROR_PATH &
end


# misc helper functions
function __aj_err
    # TODO(ting|#247): set error file location
    echo -e $argv 1>&2; false
end

# default autojump command
function j
    switch "$argv"
        case '-*' '--*'
            autojump $argv
        case '*'
            set -l output (autojump $argv)
            # Check for . and attempt a regular cd
            if [ $output = "." ]
                cd $argv
            else
                if test -d "$output"
                    set_color red
                    echo $output
                    set_color normal
                    cd $output
                else
                    __aj_err "autojump: directory '"$argv"' not found"
                    __aj_err "\n$output\n"
                    __aj_err "Try `autojump --help` for more information."
                end
            end
    end
end


# jump to child directory (subdirectory of current path)
function jc
    switch "$argv"
        case '-*'
            j $argv
        case '*'
            j (pwd) $argv
    end
end


# open autojump results in file browser
function jo
    set -l output (autojump $argv)
    if test -d "$output"
        switch $OSTYPE
            case 'linux*'
                xdg-open (autojump $argv)
            case 'darwin*'
                open (autojump $argv)
            case cygwin
                cygstart "" (cygpath -w -a (pwd))
            case '*'
                __aj_err "Unknown operating system: \"$OSTYPE\""
        end
    else
        __aj_err "autojump: directory '"$argv"' not found"
        __aj_err "\n$output\n"
        __aj_err "Try `autojump --help` for more information."
    end
end


# open autojump results (child directory) in file browser
function jco
    switch "$argv"
        case '-*'
            j $argv
        case '*'
            jo (pwd) $argv
    end
end

# launch neofetch
neofetch
EOF
