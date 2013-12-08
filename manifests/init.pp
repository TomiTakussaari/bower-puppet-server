class bower_puppet_server($environments, $enable_api='false') {
  include puppet

  if( $enable_api == 'true') {
    class {"bower_puppet_server::api":}
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

  file { ["/opt/", "/opt/puppet","/opt/puppet/environments", "/opt/puppet/scripts", "/opt/logs"]:
    ensure => directory,
    owner => "puppet",
    group => "puppet"
  }

  file { "/opt/puppet/scripts/update-modules.sh":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/scripts/update-modules.sh",
    mode => 0744,
    owner => "puppet",
    group => "puppet"
  }


  file { "/opt/puppet/environments/.bowerrc":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/environments/.bowerrc",
    owner => "puppet",
    group => "puppet"
  }

  file { "/opt/puppet/environments/bower.json":
    content => template("bower_puppet_server/opt/puppet/environments/bower.json"),
    owner => "puppet",
    group => "puppet"
  }

  file { "/opt/puppet/environments/package.json":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/environments/package.json",
    owner => "puppet",
    group => "puppet"
  }

  cron { "module update":
    command => "/opt/puppet/scripts/update-modules.sh 1> /dev/null 2>> /opt/logs/git-update-crontab.log && touch /opt/logs/git-update-crontab.log",
    minute => "1-59",
    user => "puppet"
  }
}
