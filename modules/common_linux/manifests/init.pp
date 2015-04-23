# == Class: common
#
# This sets the common requirements that all machines will receive.

class common_linux {

  motd::register{'common_linux':}

  include motd

  # We need to make sure all the users generated later by installed apps
  # don't have end up in our devops range
  user {'highpin':
    ensure  => present,
    uid     => 6000,
    comment => 'This is stupid',
    shell   => '/bin/false'
  }

  # Include devops users on all machines for the moment.
  users { 'devops':
    require  => Group['devops'],
  }

  # Include devops users on all machines for the moment.
  users { 'developers':
    require  => Group['developers'],
  }

  # Create a devops group which we can then assign users to
  group { 'devops':
    ensure => present,
    name   => 'devops',
  }

  # Create a devops group which we can then assign users to
  group { 'developers':
    ensure => present,
    name   => 'developers',
  }

  # Allow users in certain groups to have sudo access
  class { 'sudo': }

  sudo::conf { 'devops':
    priority => 10,
    content  => "%devops ALL = NOPASSWD: ALL\n",
  }

  sudo::conf { 'default':
    priority => 05,
    content  => "Defaults env_keep += \"SSH_AUTH_SOCK\"
Defaults !requiretty"
  }
}
