class owncloud::from_source () {

  class { 'apache':
    mpm_module => prefork
  }
  include 'apache::mod::php'
  apache::vhost { 'owncloud.dev':
    port               => '80',
    docroot            => '/var/www/',
    directories        => [
      { path           => '/var/www/',
        allow_override => ['All'],
      },
    ]
  }

  php::module { [ 'gd', 'mysql' ]:
    require  => Class['php'],
  }

  include 'mysql::server'
  mysql::db { 'owncloud':
    user     => 'owncloud',
    password => 'ownclouddbpassword',
    host     => 'localhost',
    grant    => ['ALL'],
  }

  include 'git'
  vcsrepo { '/var/www/owncloud':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/owncloud/core.git',
    revision => 'master',
    require  => Class['git'],
  }

  vcsrepo { '/var/www/3rdparty':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/owncloud/3rdparty.git',
    revision => 'master',
    require  => Class['git'],
  }

  vcsrepo { '/var/www/apps':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/owncloud/apps.git',
    revision => 'master',
    require  => Class['git'],
  }
}