alias ll='ls -l'
alias debian-update-install="aptitude install $(cat ~/.packages-debian-manual | awk '{print $1}')"
alias debian-update-backup="dpkg --get-selections > ~/.packages-debian-manual"
alias git-config-local-email-work="git config --local user.email fe@dev.tdt.de"
alias git-config-local-email-private="git config --local user.email Eckert.Florian@googlemail.com"
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
