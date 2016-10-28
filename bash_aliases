alias ll='ls -l'
alias debian-recover-install="aptitude install $(cat ~/.packages-debian-manual | awk '{print $1}')"
alias debian-recover-backup="dpkg --get-selections > ~/.packages-debian-manual"
alias git-config-local-email-work="git config --local user.email feckert@tdt.de"
alias git-config-local-email-private="git config --local user.email Eckert.Florian@googlemail.com"
