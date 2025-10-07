# get proot-distro alias and server password
read -p "Proot-distro alias: " DISTRO_ALIAS
read -s -p "Server root password: " SERVER_ROOT_PASSWORD

# verify proot-distro alias and password is not empty
[ ! -z "$DISTRO_ALIAS" ] || echo "[!] No alias provided, please provide proot-distro alias."
[ ! -z "$SERVER_ROOT_PASSWORD" ] || echo "[!] No password provided, please provide a root password for server."

# update and upgrade
pkg update -y && pkg pkg upgrade -y

# install proot-distro
pkg install proot-distro -y

# install debian with proot-distro
proot-distro install --override-alias "$DISTRO_ALIAS" debian

# login to debian
INSTALL_CMD="apt-get update -y && apt-get upgrade -y; apt-get install -y openssh-server python vim"
SSH_CONFIG_CMD="sed -i 's/#Port 22/Port 4723/' /etc/ssh/sshd_config; sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"
SERVER_PASSWORD_CMD="echo 'root:$SERVER_ROOT_PASSWORD' | chpasswd"
SERVER_SETUP_CMD="-- /usr/bin/bash -c '$INSTALL_CMD; $SSH_CONFIG_CMD; $SERVER_PASSWORD_CMD'; exit"
proot-distro login --isolated "$DISTRO_ALIAS" "$SERVER_SETUP_CMD"

## update repositories and install packages
#apt-get update -y && apt-get upgrade -y; apt-get install -y openssh-server python vim
#
## configure ssh server
#sed -i 's/#Port 22/Port 4723/' /etc/ssh/sshd_config; sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#
## set root password
#echo 'root:$SERVER_ROOT_PASSWORD' | chpasswd
#exit
