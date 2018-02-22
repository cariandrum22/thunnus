function thunnus.os.distro.detect -d "Return Linux distribution"
  set -l distro

  # Ubuntu, Debian
  if [ -e /etc/lsb-release; or -e /etc/os-release ]
    set $distro (lsb_release -s -d)' with '(uname -r)
  # Gentoo
  else if [ -e /etc/gentoo-release ]
    set $distro (cat /etc/gentoo-release)' with '(uname -r)
  # RHEL(CentOS)
  else if [ -e /etc/redhat-release; or -e /etc/redhat_version ]
    set $distro (string trim (cat /etc/redhat-release))' with '(uname -r)
  else
    echo 'Could not determine Linux distribution.'
    return 1
  end

  echo $distro
end
