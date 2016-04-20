alias ll='ls -l'
alias debian-recover-install="aptitude install $(cat ~/.packages-debian | awk '{print $1}')"
alias debian-recover-backup="dpkg --get-selections > ~/.packages-debian"
