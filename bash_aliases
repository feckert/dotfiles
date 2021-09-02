alias ll='ls -l'
alias debian-update-install="aptitude install $(cat ~/.packages-debian-manual | awk '{print $1}')"
alias debian-update-backup="dpkg --get-selections > ~/.packages-debian-manual"
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
alias opkg-ipkg-untar="tar -zxpvf"
alias opkg-control-untar="tar -zxvf"
alias opkg-data-untar="tar -zxvf"
