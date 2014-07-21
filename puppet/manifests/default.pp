stage { 'pre':
  before => Stage['main']
}

class pre_req {
  user { "vagrant":
    ensure => "present",
  }

  exec { 'apt-update':
    command => 'apt-get update',
    path    => '/usr/bin'
  }->
  exec { 'install_postgres':
    command => "/bin/bash -c 'LC_ALL=en_US.UTF-8; /usr/bin/apt-get -y install postgresql'",
  }
}

class { 'pre_req':
  stage => pre
}

package { ['postgresql-server-dev-9.3']:
  ensure  => 'installed',
  before  => Class['postgresql::server']
}

package { ['curl']:
  ensure => 'installed'
}->
package { ['git-core']:
  ensure => 'installed'
}->
package { ['nodejs']:
  ensure  => 'installed'
}->
package { ['redis-server']:
  ensure  => 'installed'
}->
package { ['imagemagick']:
  ensure  => 'installed'
}->
package { ['libmagickwand-dev']:
  ensure  => 'installed'
}

class { 'postgresql::globals':
  encoding => 'UTF8',
  locale   => 'en_US.UTF-8'
}->
class { 'postgresql::server':
  stage                   => main,
  locale                  => 'en_US.UTF-8',
  ip_mask_allow_all_users => '0.0.0.0/0',
  listen_addresses        => '*',
  ipv4acls                => ['local all all md5'],
  postgres_password       => 'postgres',
  require                 => User['vagrant']
}->
postgresql::server::role { 'vagrant':
  createdb      => true,
  login         => true,
  password_hash => postgresql_password("vagrant", "vagrant"),
}

include git

class { 'rbenv': }
rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::build { '2.1.2': global => true }