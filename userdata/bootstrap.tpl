#!/bin/bash -v

set -e -x

# Logger
exec > >(tee /var/log/user-data_3rd-bootstrap.log || logger -t user-data -s 2>/dev/console) 2>&1

#-------------------------------------------------------------------------------
# Set UserData Parameter
#-------------------------------------------------------------------------------

if [ -f /tmp/userdata-parameter ]; then
    source /tmp/userdata-parameter
fi

if [[ -z "${Language}" || -z "${Timezone}" || -z "${VpcNetwork}" ]]; then
    # Default Language
    Language="en_US.UTF-8"
    # Default Timezone
    Timezone="Asia/Tokyo"
    # Default VPC Network
    VpcNetwork="IPv4"
fi

# echo
echo $Language
echo $Timezone
echo $VpcNetwork

#-------------------------------------------------------------------------------
# Parameter Settings
#-------------------------------------------------------------------------------

# Parameter Settings
# CWAgentConfig="https://raw.githubusercontent.com/usui-tk/amazon-ec2-userdata/master/Config_AmazonCloudWatchAgent/AmazonCloudWatchAgent_Ubuntu-22.04-LTS-HVM.json"

#-------------------------------------------------------------------------------
# Acquire unique information of Linux distribution
#  - Ubuntu 22.04 LTS
#    https://discourse.ubuntu.com/t/jammy-jellyfish-release-notes/24668
#	 https://wiki.ubuntu.com/JammyJellyfish/ReleaseNotes/Ja
#
#    https://help.ubuntu.com/
#    https://help.ubuntu.com/lts/serverguide/index.html
#    https://help.ubuntu.com/lts/installation-guide/amd64/index.html
#    http://packages.ubuntu.com/ja/
#
#	 https://cloud-images.ubuntu.com/locator/ec2/
#    https://help.ubuntu.com/community/EC2StartersGuide
#
#    https://aws.amazon.com/marketplace/pp/prodview-f2if34z3a4e3i
#    https://aws.amazon.com/marketplace/pp/prodview-uy7jg4dds3qjw
#
#-------------------------------------------------------------------------------

# Command Non-Interactive Mode
export DEBIAN_FRONTEND=noninteractive

# Cleanup repository information
apt clean -y -q

# Show Linux Distribution/Distro information
if [ $(command -v lsb_release) ]; then
    lsb_release -a
fi

# Show Linux System Information
uname -a

# Show Linux distribution release Information
if [ -f /etc/os-release ]; then
    cat "/etc/os-release"
fi

# Default installation package [apt command]
apt list --installed >/tmp/command-log_apt_installed-package.txt

# Default repository package [apt command]
apt list >/tmp/command-log_apt_repository-package-list.txt

# systemd unit files
systemctl list-unit-files --all --no-pager >/tmp/command-log_systemctl_list-unit-files.txt

# systemd service config
systemctl list-units --type=service --all --no-pager >/tmp/command-log_systemctl_list-service-config.txt

#-------------------------------------------------------------------------------
# Default Package Update
#-------------------------------------------------------------------------------

# apt repository metadata Clean up
apt clean -y -q

# apt repository metadata update
apt update -y -q

# Uninstalling the Oracle Cloud Agent
# https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/manage-plugins.htm
apt remove -y -q oracle-cloud-agent

# Package Install Ubuntu apt Administration Tools (from Ubuntu Official Repository)
apt install -y -q apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Default Package Update
apt update -y -q && apt upgrade -y -q && apt full-upgrade -y -q

#-------------------------------------------------------------------------------
# Custom Package Installation
#-------------------------------------------------------------------------------

# Package Install Ubuntu System Administration Tools (from Ubuntu Official Repository)
apt install -y -q acpid acpitool arptables atop bash-completion bcc bcftools binutils blktrace bpfcc-tools byobu chrony collectd collectl colordiff crash cryptol curl dateutils debian-goodies dstat ebtables ethtool expect file fio fping fzf gdisk git glances hardinfo hdparm htop httping iftop inotify-tools intltool iotop ipcalc iperf3 iptraf-ng ipv6calc ipv6toolkit jc jnettop jp jq kexec-tools lsb-release lsof lvm2 lzop manpages mc mdadm mlocate moreutils mtr ncdu ncompress needrestart netcat netsniff-ng nftables nload nmap numactl numatop nvme-cli parted psmisc python3-bpfcc rsync rsyncrypto screen secure-delete shellcheck snmp sosreport strace stressapptest symlinks sysfsutils sysstat tcpdump time timelimit traceroute tree tzdata unzip usermode util-linux wdiff wget zip zstd
apt install -y -q cifs-utils nfs-common nfs4-acl-tools nfstrace nfswatch
apt install -y -q libiscsi-bin lsscsi scsitools sdparm sg3-utils
# apparmor用途类似 Selinux
# apt install -y -q apparmor apparmor-easyprof apparmor-profiles apparmor-profiles-extra apparmor-utils dh-apparmor
apt install -y -q pcp pcp-conf pcp-manager

# Package Install Python 3 Runtime (from Ubuntu Official Repository)
apt install -y -q python3 python3-pip python3-setuptools python3-testtools python3-ubuntutools python3-wheel

#-------------------------------------------------------------------------------
# Custom Package Installation [Ansible]
# http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-apt-ubuntu
#-------------------------------------------------------------------------------

apt install -y -q software-properties-common

apt install -y -q ansible

apt show ansible

ansible --version

ansible localhost -m setup

#-------------------------------------------------------------------------------
# Custom Package Installation [Terraform]
# https://www.terraform.io/docs/cli/install/apt.html
#-------------------------------------------------------------------------------

# Import GPG Key File
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

# Add the HashiCorp Linux Repository
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# apt repository metadata Clean up
apt clean -y

# Update and install Terraform Infrastructure as Code (IaC) Tools (from HashiCorp Linux Repository)
apt update -y -q && apt install -y -q terraform

# Package Information
apt show terraform

terraform version

# Configure terraform software

## terraform -install-autocomplete
cat >/etc/profile.d/terraform.sh <<__EOF__
if [ -n "\$BASH_VERSION" ]; then
   complete -C /usr/bin/terraform terraform
fi
__EOF__

source /etc/profile.d/terraform.sh

#-------------------------------------------------------------------------------
# Custom Package Installation [Nomad]
# https://developer.hashicorp.com/nomad/docs/install
#-------------------------------------------------------------------------------

apt update -y -q && apt install -y -q nomad

# Nomad Install CNI plugins
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$([ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz &&
    mkdir -p /opt/cni/bin &&
    tar -C /opt/cni/bin -xzf cni-plugins.tgz
# Nomad sysctl tuning
echo 'net.bridge.bridge-nf-call-arptables=1' >>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables=1' >>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables=1' >>/etc/sysctl.conf

nomad version

#-------------------------------------------------------------------------------
# Custom Package Installation [Docker & Docker compose]
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
#-------------------------------------------------------------------------------

# Install docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu

# Install docker compose
apt install -y -q docker-compose-plugin

#-------------------------------------------------------------------------------
# Custom Package Installation [Tailscale]
# https://tailscale.com/kb/1187/install-ubuntu-2204/
#-------------------------------------------------------------------------------

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
apt update -y -q && apt install -y -q tailscale
# Expires Jun 22, 2023 at 3:46 PM GMT+8
tailscale up --ssh --authkey="${tailscale_authkey}"
tailscale ip -4

#-------------------------------------------------------------------------------
# Custom Package Installation [K3s]
# https://docs.k3s.io/zh/installation/configuration
#-------------------------------------------------------------------------------

# 1.24 后内存使用量增加
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true INSTALL_K3S_SKIP_START=true INSTALL_K3S_VERSION=v1.23.17+k3s1 sh -

#-------------------------------------------------------------------------------
# Custom Package Clean up
#-------------------------------------------------------------------------------

# apt repository metadata Clean up
apt clean -y -q

# Default Package Update
apt update -y -q && apt upgrade -y -q && apt full-upgrade -y -q

# Clean up package
apt autoremove -y -q

#-------------------------------------------------------------------------------
# System information collection
#-------------------------------------------------------------------------------

# CPU Information [cat /proc/cpuinfo]
cat /proc/cpuinfo

# CPU Information [lscpu]
lscpu

lscpu --extended

# Memory Information [cat /proc/meminfo]
cat /proc/meminfo

# Memory Information [free]
free

# Disk Information(Partition) [parted -l]
parted -l

# Disk Information(MountPoint) [lsblk -f]
lsblk -f

# Disk Information(File System) [df -khT]
df -khT

# Network Information(Network Interface) [ip addr show]
ip addr show

# Network Information(Routing Table) [ip route show]
ip route show

# Network Information(Firewall Service) [Uncomplicated firewall]
if [ $(command -v ufw) ]; then
    if [ $(systemctl is-enabled ufw) = "enabled" ]; then
        # Network Information(Firewall Service Status) [ufw status]
        ufw status verbose

        # Network Information(Firewall Service Disabled) [ufw disable]
        ufw disable

        # Network Information(Firewall Service Status) [systemctl status -l ufw]
        systemctl status -l ufw
        systemctl disable ufw
        systemctl status -l ufw
    fi
fi

# Linux Security Information(AppArmor)
if [ $(command -v aa-status) ]; then
    if [ $(systemctl is-enabled apparmor) = "enabled" ]; then
        # Linux Security Information(AppArmor) [aa-status]
        aa-status
    fi
fi

#-------------------------------------------------------------------------------
# Configure Tuned
#-------------------------------------------------------------------------------

# Package Install Tuned
apt install -y -q tuned tuned-utils

apt show tuned

systemctl daemon-reload

systemctl restart tuned

systemctl status -l tuned

# Configure Tuned software (Start Daemon tuned)
if [ $(systemctl is-enabled tuned) = "disabled" ]; then
    systemctl enable tuned
    systemctl is-enabled tuned
fi

# Configure Tuned software (select profile - throughput-performance)
tuned-adm list

tuned-adm active
tuned-adm profile throughput-performance
tuned-adm active

#-------------------------------------------------------------------------------
# Configure ACPI daemon (Advanced Configuration and Power Interface)
#-------------------------------------------------------------------------------

# Configure ACPI daemon software (Install acpid Package)
apt install -y -q acpid acpitool

apt show acpid

systemctl daemon-reload

systemctl restart acpid

systemctl status -l acpid

# Configure NTP Client software (Start Daemon chronyd)
if [ $(systemctl is-enabled acpid) = "disabled" ]; then
    systemctl enable acpid
    systemctl is-enabled acpid
fi

#-------------------------------------------------------------------------------
# Configure Disable automatic processing (apt-daily.timer), (apt-daily-upgrade.timer)
#-------------------------------------------------------------------------------

# Configure Disable automatic processing (apt-daily.timer)
systemctl cat apt-daily.timer

sed -i 's/Persistent=true/Persistent=false/g' /lib/systemd/system/apt-daily.timer

systemctl cat apt-daily.timer

systemctl daemon-reload

# Configure Disable automatic processing (apt-daily-upgrade.timer)
systemctl cat apt-daily-upgrade.timer

sed -i 's/Persistent=true/Persistent=false/g' /lib/systemd/system/apt-daily-upgrade.timer

systemctl cat apt-daily-upgrade.timer

systemctl daemon-reload

#-------------------------------------------------------------------------------
# System Setting
#-------------------------------------------------------------------------------

# Setting SystemClock and Timezone
if [ "${Timezone}" = "Asia/Tokyo" ]; then
    echo "# Setting SystemClock and Timezone -> $Timezone"
    date
    timedatectl status --no-pager
    timedatectl set-timezone Asia/Tokyo
    timedatectl status --no-pager
    dpkg-reconfigure --frontend noninteractive tzdata
    date
elif [ "${Timezone}" = "UTC" ]; then
    echo "# Setting SystemClock and Timezone -> $Timezone"
    date
    timedatectl status --no-pager
    timedatectl set-timezone UTC
    timedatectl status --no-pager
    dpkg-reconfigure --frontend noninteractive tzdata
    date
else
    echo "# Default SystemClock and Timezone"
    date
    timedatectl status --no-pager
    dpkg-reconfigure --frontend noninteractive tzdata
    date
fi

# Setting System Language
if [ "${Language}" = "ja_JP.UTF-8" ]; then
    # Custom Package Installation [language-pack-ja]
    apt install -y -q language-pack-ja-base language-pack-ja fonts-ipafont

    echo "# Setting System Language -> $Language"
    locale
    localectl status --no-pager
    localectl list-locales --no-pager | grep ja_
    localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
    dpkg-reconfigure --frontend noninteractive locales
    localectl status --no-pager
    locale
    strings /etc/default/locale
    source /etc/default/locale
elif [ "${Language}" = "en_US.UTF-8" ]; then
    echo "# Setting System Language -> $Language"
    locale
    localectl status --no-pager
    localectl list-locales --no-pager | grep en_
    localectl set-locale LANG=en_US.UTF-8
    dpkg-reconfigure --frontend noninteractive locales
    localectl status --no-pager
    locale
    strings /etc/default/locale
    source /etc/default/locale
else
    echo "# Default Language"
    locale
    localectl status --no-pager
    strings /etc/default/locale
fi

# Setting IP Protocol Stack (IPv4 Only) or (IPv4/IPv6 Dual stack)
if [ "${VpcNetwork}" = "IPv4" ]; then
    echo "# Setting IP Protocol Stack -> $VpcNetwork"

    # Disable IPv6 Uncomplicated Firewall (ufw)
    if [ -e /etc/default/ufw ]; then
        sed -i "s/IPV6=yes/IPV6=no/g" /etc/default/ufw
    fi

    # Disable IPv6 Kernel Module
    echo "options ipv6 disable=1" >>/etc/modprobe.d/ipv6.conf

    # Disable IPv6 Kernel Parameter
    sysctl -a

    DisableIPv6Conf="/etc/sysctl.d/99-ipv6-disable.conf"

    cat /dev/null >$DisableIPv6Conf
    echo '# Custom sysctl Parameter for ipv6 disable' >>$DisableIPv6Conf
    echo 'net.ipv6.conf.all.disable_ipv6 = 1' >>$DisableIPv6Conf
    echo 'net.ipv6.conf.default.disable_ipv6 = 1' >>$DisableIPv6Conf

    sysctl --system
    sysctl -p

    sysctl -a | grep -ie "local_port" -ie "ipv6" | sort
elif [ "${VpcNetwork}" = "IPv6" ]; then
    echo "# Show IP Protocol Stack -> $VpcNetwork"
    echo "# Show IPv6 Network Interface Address"
    ifconfig
    echo "# Show IPv6 Kernel Module"
    lsmod | awk '{print $1}' | grep ipv6
    echo "# Show Network Listen Address and report"
    netstat -an -A inet6
    echo "# Show Network Routing Table"
    netstat -r -A inet6
else
    echo "# Default IP Protocol Stack"
    echo "# Show IPv6 Network Interface Address"
    ifconfig
    echo "# Show IPv6 Kernel Module"
    lsmod | awk '{print $1}' | grep ipv6
    echo "# Show Network Listen Address and report"
    netstat -an -A inet6
    echo "# Show Network Routing Table"
    netstat -r -A inet6
fi

#-------------------------------------------------------------------------------
# Reboot
#-------------------------------------------------------------------------------

# Instance Reboot
reboot
