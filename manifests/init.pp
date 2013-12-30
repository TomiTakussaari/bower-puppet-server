class bower_puppet_server($environments, $enable_api='false', $root_directory="/opt", $my_environment) {
  class {"puppet": 
    my_environment => $my_environment
  }

  if( $enable_api == 'true') {
    class {"bower_puppet_server::api":
      root_directory => $root_directory
    }
  }

  package { "git":
    ensure => installed
  }

  package { "cronie":
    ensure => installed
  }

  package { 'npm':
    ensure => installed,
    require => Yumrepo['epel']
  }

  yumrepo { "epel":
    baseurl => "http://download.fedoraproject.org/pub/epel/6/\$basearch",
    descr => "EPEL repo",
    enabled => 1,
    gpgcheck => 0,
  }

  file { ["$root_directory/puppet","$root_directory/puppet/environments", "$root_directory/puppet/scripts", "$root_directory/logs"]:
    ensure => directory,
    owner => "puppet",
    group => "puppet"
  }

  file { "$root_directory/puppet/scripts/update-modules.sh":
    content => template("bower_puppet_server/opt/puppet/scripts/update-modules.sh"),
    mode => 0744,
    owner => "puppet",
    group => "puppet"
  }


  file { "$root_directory/puppet/environments/.bowerrc":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/environments/.bowerrc",
    owner => "puppet",
    group => "puppet"
  }

  file { "$root_directory/puppet/environments/bower.json":
    content => template("bower_puppet_server/opt/puppet/environments/bower.json"),
    owner => "puppet",
    group => "puppet"
  }

  file { "$root_directory/puppet/environments/package.json":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/environments/package.json",
    owner => "puppet",
    group => "puppet"
  }

  cron { "module update":
    command => "$root_directory/puppet/scripts/update-modules.sh 1> /dev/null 2>> $root_directory/logs/git-update-crontab.log && touch $root_directory/logs/git-update-crontab.log",
    minute => "1-59",
    user => "puppet"
  }
}
