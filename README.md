# Server management scripts

# ubuntuconfig

This describes the script.

## how to use ubuntuconfig
store this script and dockerconfig in /usr/local/bin

to run "sudo ubuntuconfig"

to install docker run "sudo ubuntuconfig d"

to disable IPv6 with apt run "sudo ubuntuconfig i"

multiple install conditions can be invoked at once e.g. "di"

upon completion script outputs results to /home/$USER/results.log

logging in /var/log/ubuntuconfig.log and /var/log/ubuntuconfig_errors.log

## user variables
The default user values are below. These can be changed by modifiying the script.

```
dtime="America/Detroit" #see tz list https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ssh_port="4242" #change port 22 for SSH to alternative
ssh_pub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxPQteXvxJFskR1IVkkA8x9Fav1rUMLWdffSAbJnhiz theverbaldotnet" #ssh public key ed25519
ddir="/docker" #docker directory
```

# debainconfig

This describes the script.

## how to use debianconfig
store this script and dockerconfig in /usr/local/bin

to run "sudo debianconfig"

to install docker run "sudo debianconfig d"

to disable IPv6 with apt run "sudo debianconfig i"

multiple install conditions can be invoked at once e.g. "di"

upon completion script outputs results to /home/$USER/results.log

logging in /var/log/debianconfig.log and /var/log/debianconfig_errors.log

## user variables
The default user values are below. These can be changed by modifiying the script.

```
dtime="America/Detroit" #see tz list https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ssh_port="4242" #change port 22 for SSH to alternative
ssh_pub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxPQteXvxJFskR1IVkkA8x9Fav1rUMLWdffSAbJnhiz theverbaldotnet" #ssh public key ed25519
ddir="/docker" #docker directory
```


# dockerconfig
Can be run by itself or called by distro config script.

## how to use dockerconfig
store this script in /usr/local/bin

to run "sudo dockerconfig"

can be called from ubuntuconfig or debianconfig and will inherit variables from that script

logging in /var/log/dockerconfig.log and /var/log/dockerconfig_errors.log

# user variables
compose="2.19.0" #get the latest version from https://github.com/docker/compose/releases
dockerlocation="/docker"
