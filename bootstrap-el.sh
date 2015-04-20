#!/usr/bin/env bash
# Bootstraps the VM, ready for provisioning with Puppet.

[ -e /etc/redhat-release ] && VERSION=$(egrep -o "[[:digit:]]" /etc/redhat-release) || exit 1

MAJOR=$(echo $VERSION | awk '{print $1}')

case $MAJOR in
  5|6|7)
    ENTERPRISE_VERSION="el-${MAJOR}"
    ;;
  20|21)
    ENTERPRISE_VERSION="fedora-${MAJOR}"
    ;;
  *)
    echo "Unsupported EL version"
    exit 1
    ;;
esac

#case $1 in
#  el-5|el-6|el-7|fedora-20|fedora-21)
#    ENTERPRISE_VERSION=$1
#    ;;
#  *)
#    echo '- Please provide a valid enterprise version as argument'
#    echo '  versions: el-5, el-6, el-7, fedora-20, fedora-21'
#    exit 1
#    ;;
#esac

function conf_server() {
  MemTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  PMemory=$(expr $(((MemTotal/2)/1024)))

  if [ $PMemory -lt 256 ]; then
    PMemory=256
  fi

  sed -i "s/2g/${PMemory}m/g" /etc/sysconfig/puppetserver
  gem install librarian-puppet --no-ri --no-rdoc
}



echo ''
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo "Bootstrapping the ${ENTERPRISE_VERSION} VM: ${HOSTNAME}"

# Are we punching above our weight?
if [ "$EUID" -ne "0" ]; then
  echo '- The bootstrap script must be run as root!'
  exit 1
fi

# Download and register the Puppet Labs package.
echo '- Registering the Puppet Collection package...'

yum localinstall -y http://yum.puppetlabs.com/puppetlabs-release-pc1-${ENTERPRISE_VERSION}.noarch.rpm

if [ $(hostname -s) == "puppet" ]; then
 echo '- Installing Puppet Server...'
 yum install -y puppetserver
 conf_server
else
# Update the packages.
#echo '- Updating the packages...'
#yum -y update >/dev/null

# Install Puppet.
  echo '- Installing Puppet Agent...'
  yum install -y puppet-agent >/dev/null
fi

# Add puppet to path
echo 'PATH=$PATH:/opt/puppetlabs/puppet/bin' > /etc/profile.d/puppet_path.sh

# All done.
echo "- ${HOSTNAME}: VM is bootstrapped and ready to go..."
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo ''
