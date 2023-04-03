#cloud-config
merge_how:
 - name: list
   settings: [append]
 - name: dict
   settings: [no_replace, recurse_list]

timezone: Asia/Tokyo
locale: en_US.UTF-8

users:
  - name: casey
    primary_group: casey
    groups:  [adm, admin, audio, cdrom, dialout, dip, floppy, lxd, netdev, plugdev, sudo, video, users]
    lock_passwd: true
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/zsh
    ssh_authorized_keys: 
      - ${ssh_authorized_keys}

package_update: true
package_upgrade: true

apt:
  sources:
    hashicorp.list:
      source: "deb https://apt.releases.hashicorp.com $RELEASE main"
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        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
        =FdUF
        -----END PGP PUBLIC KEY BLOCK-----
packages:
  - acpid
  - acpitool
  - arptables
  - atop
  - bash-completion
  - bcc
  - bcftools
  - binutils
  - blktrace
  - bpfcc-tools
  - byobu
  - cifs-utils
  - chrony
  - collectd
  - collectl
  - colordiff
  - crash
  - cryptol
  - curl
  - dateutils
  - debian-goodies
  - ebtables
  - ethtool
  - expect
  - file
  - fio
  - fonts-powerline
  - fping
  - fzf
  - gdisk
  - git
  - glances
  - hardinfo
  - hdparm
  - htop
  - httpie
  - httping
  - iftop
  - inotify-tools
  - intltool
  - iotop
  - ipcalc
  - iperf3
  - iptraf-ng
  - ipv6calc
  - ipv6toolkit
  - jc
  - jnettop
  - jp
  - jq
  - kexec-tools
  - libiscsi-bin
  - lsb-release
  - lsof
  - lsscsi
  - lvm2
  - lzop
  - manpages
  - mc
  - mdadm
  - mlocate
  - moreutils
  - mtr
  - ncdu
  - ncompress
  - needrestart
  - netcat
  - net-tools
  - netsniff-ng
  - nfs-common
  - nfs4-acl-tools
  - nfstrace
  - nfswatch
  - nftables
  - nload
  - nmap
  - nomad
  - numactl
  - numatop
  - nvme-cli
  - parted
  - pcp
  - pcp-conf
  - pcp-manager
  - powerline
  - psmisc
  - python3
  - python3-pip
  - python3-setuptools
  - python3-testtools
  - python3-ubuntutools
  - python3-wheel
  - python3-bpfcc
  - rsync
  - rsyncrypto
  - screen
  - scsitools
  - sdparm
  - secure-delete
  - sg3-utils
  - shellcheck
  - snmp
  - software-properties-common
  - sosreport
  - strace
  - stressapptest
  - symlinks
  - sysfsutils
  - sysstat
  - tcpdump
  - terraform
  - time
  - timelimit
  - traceroute
  - tree
  - tuned
  - tuned-utils
  - tzdata
  - unzip
  - usermode
  - util-linux
  - wdiff
  - wget
  - zip
  - zsh
  - zsh-autosuggestions
  - zsh-common
  - zsh-static
  - zsh-syntax-highlighting
  - zstd
ansible:
  install_method: pip
  package_name: ansible
  run_user: casey
  galaxy:
    actions:
      - ["/home/casey/.local/bin/ansible-galaxy", "collection", "install", "community.general"]




runcmd:
  - |
    update-alternatives --set editor /usr/bin/vim.basic
  - |
    echo 'export PATH="/home/casey/.local/bin:$PATH"' >>/home/casey/.bashrc
    echo 'export PATH="/home/casey/.local/bin:$PATH"' >>/home/casey/.zshrc
  - |
    cat >/etc/profile.d/terraform.sh <<__EOF__
    if [ -n "\$BASH_VERSION" ]; then
      complete -C /usr/bin/terraform terraform
    fi
    __EOF__
    source /etc/profile.d/terraform.sh
  - |
    curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$([ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz &&
    mkdir -p /opt/cni/bin &&
    tar -C /opt/cni/bin -xzf cni-plugins.tgz
  - |
    echo 'net.bridge.bridge-nf-call-arptables=1' >>/etc/sysctl.conf
    echo 'net.bridge.bridge-nf-call-ip6tables=1' >>/etc/sysctl.conf
    echo 'net.bridge.bridge-nf-call-iptables=1' >>/etc/sysctl.conf
  - |
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker casey
    apt install -y -q docker-compose-plugin
  - |
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
    apt update -y -q && apt install -y -q tailscale
  - |
    tailscale up --ssh --authkey=${tailscale_authkey}
  - |
    cat >/etc/systemd/system/tailscale-weekly-update.service <<__EOF__
    [Unit]
    Description=Tailscale node agent
    Wants=tailscale-weekly-update.timer

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/tailscale update -yes

    [Install]
    WantedBy=multi-user.target
    __EOF__
  - |
    cat >/etc/systemd/system/tailscale-weekly-update.timer <<__EOF__
    [Unit]
    Description=Tailscale node agent
    Requires=tailscale-weekly-update.service

    [Timer]
    Unit=tailscale-weekly-update.service
    OnCalendar=weekly

    [Install]
    WantedBy=timers.target
    __EOF__
  - |
    systemctl enable tailscale-weekly-update.timer  
  - |
    curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true INSTALL_K3S_SKIP_START=true INSTALL_K3S_VERSION=v1.23.17+k3s1 sh -
  - |
    ZDOTDIR="/home/casey" ZSH="/home/casey/.oh-my-zsh" CHSH="no" RUNZSH="no" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chown -R casey:casey /home/casey/.oh-my-zsh
    chown casey:casey /home/casey/.zshrc
    curl -sS https://starship.rs/install.sh | sh -s - -y
    echo 'eval "$(starship init bash)"' >>/home/casey/.bashrc
    echo 'eval "$(starship init zsh)"' >>/home/casey/.zshrc || echo 'starship init zsh failed'
  - |
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
  - |
    systemctl daemon-reload
    systemctl restart tuned
  - |
    if [ $(systemctl is-enabled tuned) = "disabled" ]; then
        systemctl enable tuned
        systemctl is-enabled tuned
    fi
  - |
    tuned-adm list
    tuned-adm active
    tuned-adm profile throughput-performance
    tuned-adm active
  - |
    systemctl daemon-reload
    systemctl restart acpid
  - |
    if [ $(systemctl is-enabled acpid) = "disabled" ]; then
        systemctl enable acpid
        systemctl is-enabled acpid
    fi
  - |
    if [ -e /etc/default/ufw ]; then
        sed -i "s/IPV6=yes/IPV6=no/g" /etc/default/ufw
    fi
    echo "options ipv6 disable=1" >>/etc/modprobe.d/ipv6.conf
    sysctl -a
    DisableIPv6Conf="/etc/sysctl.d/99-ipv6-disable.conf"
    cat /dev/null >$DisableIPv6Conf
    echo '# Custom sysctl Parameter for ipv6 disable' >>$DisableIPv6Conf
    echo 'net.ipv6.conf.all.disable_ipv6 = 1' >>$DisableIPv6Conf
    echo 'net.ipv6.conf.default.disable_ipv6 = 1' >>$DisableIPv6Conf
    echo 'net.ipv4.ip_forward = 1' >>/etc/sysctl.conf
    echo 'net.ipv4.conf.all.proxy_arp = 1' >>/etc/sysctl.conf
    echo 'fs.aio-max-nr = 1048576' >>/etc/sysctl.conf
    echo 'kernel.shmmni = 4096' >>/etc/sysctl.conf
    echo 'kernel.sem = 250 32000 100 128' >>/etc/sysctl.conf
    echo 'fs.file-max = 6815744' >>/etc/sysctl.conf
    echo 'net.ipv4.ip_local_port_range = 20000 65000' >>/etc/sysctl.conf
    echo 'net.core.rmem_default = 262144' >>/etc/sysctl.conf
    echo 'net.core.wmem_default = 262144' >>/etc/sysctl.conf
    echo 'net.core.rmem_max = 4194304' >>/etc/sysctl.conf
    echo 'net.core.wmem_max = 1048576' >>/etc/sysctl.conf
    echo 'vm.overcommit_memory = 1' >>/etc/sysctl.conf
    echo 'vm.dirty_background_ratio = 5' >>/etc/sysctl.conf
    echo 'vm.dirty_ratio = 10' >>/etc/sysctl.conf
    echo 'fs.nr_open = 1048576' >>/etc/sysctl.conf
    echo 'net.ipv4.tcp_max_syn_backlog = 1024' >>/etc/sysctl.conf
    echo 'net.core.somaxconn = 4096' >>/etc/sysctl.conf
    sysctl --system
    sysctl -p
  - |
    echo '*        soft            nproc   unlimited' >>/etc/security/limits.conf
    echo '*        hard            nproc   unlimited' >>/etc/security/limits.conf
    echo '*        soft            nofile  65535' >>/etc/security/limits.conf
    echo '*        hard            nofile  65535' >>/etc/security/limits.conf  
  - |
    git config --global user.name "east4ming"
    git config --global user.email "cuikaidong@foxmail.com"
    git config --system credential.helper store || echo 'git config credential failed'
  - |
    apt autoremove -y -q
  - |
    reboot
