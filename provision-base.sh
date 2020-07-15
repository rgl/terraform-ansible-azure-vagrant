#!/bin/bash
set -euxo pipefail

# configure apt for not asking interactive questions.
echo 'Defaults env_keep += "DEBIAN_FRONTEND"' >/etc/sudoers.d/env_keep_apt
chmod 440 /etc/sudoers.d/env_keep_apt
export DEBIAN_FRONTEND=noninteractive

# upgrade the system.
apt-get update
apt-get dist-upgrade -y


#
# install tcpdump for being able to capture network traffic.

apt-get install -y tcpdump


#
# install vim.

apt-get install -y --no-install-recommends vim
cat >/etc/vim/vimrc.local <<'EOF'
syntax on
set background=dark
set esckeys
set ruler
set laststatus=2
set nobackup
EOF


#
# configure the shell.

cat >/etc/profile.d/login.sh <<'EOF'
[[ "$-" != *i* ]] && return
export EDITOR=vim
export PAGER=less
alias l='ls -lF --color'
alias ll='l -a'
alias h='history 25'
alias j='jobs -l'
EOF

cat >/etc/inputrc <<'EOF'
set input-meta on
set output-meta on
set show-all-if-ambiguous on
set completion-ignore-case on
"\e[A": history-search-backward
"\e[B": history-search-forward
"\eOD": backward-word
"\eOC": forward-word
EOF

cat >~/.bash_history <<'EOF'
source /opt/ansible/bin/activate && cd /vagrant
EOF

# configure the vagrant user home.
su vagrant -c bash <<'EOF-VAGRANT'
set -euxo pipefail

cat >~/.bash_history <<'EOF'
sudo -i
EOF
EOF-VAGRANT

#
# provision useful tools.

apt-get install -y unzip jq jo
