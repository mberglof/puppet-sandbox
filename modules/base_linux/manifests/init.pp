# This is the base_linux module that we might not need

class base_linux {

  # I suggest using this file to control common linux box properties
  # such as, user keys, monitoring, s3cmd, then switch out to the
  # project after done

  motd::register { 'base_linux': }
  motd::register { 'puppet_environment':
    content => "Puppet Environment: ${::environment}"
  }

  # Include the common linux module
  class { 'common_linux': }

}
