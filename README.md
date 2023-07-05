# Server management scripts

These scripts are intended to automate the post installation of a server running Ubuntu 22.04 or Debian 12. The companion script installs Docker and can be invoked by itself or as part of the distribution post installation script. 

The distro config scripts update and upgrade all packages, install various replacement packages (e.g. Nala, batcat, exa, etc.), configure NTP, create a .bash_aliases file with my aliases, configure UFW, harden SSH, and enable unattended-upgrades. 

The Docker config script installs docker-ce, docker compose (version defined in the script), and configures Portainer on Port 9443.

All scripts should run on arm64 but have not yet been tested.

## ubuntuconfig

Tested on Ubuntu 22.04.

### how to use ubuntuconfig
store this script and dockerconfig in /usr/local/bin

to run "sudo ubuntuconfig"

to install docker run "sudo ubuntuconfig d"

to disable IPv6 with apt run "sudo ubuntuconfig i"

multiple install conditions can be invoked at once e.g. "di"

upon completion script outputs results to /home/$USER/results.log

logging in /var/log/ubuntuconfig.log and /var/log/ubuntuconfig_errors.log

after running the script run "nala fetch" and pick the three fastest mirrors

### user variables
The default user values are below. These can be changed by modifiying the script.

```
dtime="America/Detroit" #see tz list https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ssh_port="4242" #change port 22 for SSH to alternative
ssh_pub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxPQteXvxJFskR1IVkkA8x9Fav1rUMLWdffSAbJnhiz theverbaldotnet" #ssh public key ed25519
ddir="/docker" #docker directory
```

## debainconfig

Tested on Debian 12.

### how to use debianconfig
store this script and dockerconfig in /usr/local/bin

to run "sudo debianconfig"

to install docker run "sudo debianconfig d"

to disable IPv6 with apt run "sudo debianconfig i"

multiple install conditions can be invoked at once e.g. "di"

upon completion script outputs results to /home/$USER/results.log

logging in /var/log/debianconfig.log and /var/log/debianconfig_errors.log

after running the script run "nala fetch" and pick the three fastest mirrors

### user variables
The default user values are below. These can be changed by modifiying the script.

```
dtime="America/Detroit" #see tz list https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ssh_port="4242" #change port 22 for SSH to alternative
ssh_pub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxPQteXvxJFskR1IVkkA8x9Fav1rUMLWdffSAbJnhiz theverbaldotnet" #ssh public key ed25519
ddir="/docker" #docker directory
```


## dockerconfig
Can be run by itself or called by distro config script.

### how to use dockerconfig
store this script in /usr/local/bin

to run "sudo dockerconfig"

can be called from ubuntuconfig or debianconfig and will inherit variables from that script

logging in /var/log/dockerconfig.log and /var/log/dockerconfig_errors.log

after running the script run "dcup" to launch Portainer

### user variables
```
compose="2.19.0" #get the latest version from https://github.com/docker/compose/releases
dockerlocation="/docker" #this is overridden if run from debianconfig or ubuntuconfig
```
