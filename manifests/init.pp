class bower_puppet_server($environments) {
  include puppet
  include nodejs

  package { "git":
    ensure => installed
  }

  package { "cronie":
    ensure => installed
  }

  file { ["/opt/", "/opt/puppet","/opt/puppet/environments", "/opt/puppet/scripts", "/opt/logs", "/opt/puppet/bower-puppet-api"]:
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

  file { "/opt/puppet/bower-puppet-api/bower-puppet-api.js":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/bower-puppet-api/bower-puppet-api.js",
    mode => 0744,
    owner => "puppet",
    group => "puppet"
  }

  file { "/opt/puppet/bower-puppet-api/package.json":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/bower-puppet-api/package.json",
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


  file { "/etc/init.d/bower-puppet-api":
    ensure => present,
    source => "puppet:///modules/bower_puppet_server/etc/init.d/bower-puppet-api",
    owner => "root",
    group => "root",
    mode => 0744,
  }

  service { "bower-puppet-api":
    enable => true,
    ensure => running,
    hasrestart => false,
    hasstatus => true,
    require => [
          File["/etc/init.d/bower-puppet-api"], Package["npm"], File["/opt/puppet/bower-puppet-api/bower-puppet-api.js"], File["/opt/puppet/bower-puppet-api/package.json"]
    ]
  }
  cron { "module update":
    command => "/opt/puppet/scripts/update-modules.sh 1> /dev/null 2>> /opt/logs/git-update-crontab.log && touch /opt/logs/git-update-crontab.log",
    minute => "1-59",
    user => "puppet"
  }
}
