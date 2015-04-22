
class motd {
  $motd = '/etc/motd'

  concat { $motd:
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  concat::fragment{ 'motd_header':
    target  => $motd,
    content => "\nPuppet modules on this server:\n\n",
    order   => '01'
  }

  # local users on the machine can append to motd by just creating
  # /etc/motd.local
# concat::fragment{ 'motd_local':
#  target => $motd,
#  source => '/etc/motd.local',
#  order  => '15'
# }
}
