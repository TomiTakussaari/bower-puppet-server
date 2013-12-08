class bower_puppet_server::api {

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

  file { ["/opt/puppet/bower-puppet-api"]:
    ensure => directory,
    owner => "puppet",
    group => "puppet"
  }

  file { "/opt/puppet/bower-puppet-api/bower-puppet-api.js":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/bower-puppet-api/bower-puppet-api.js",
    mode => 0744,
    owner => "puppet",
    group => "puppet",
    require => File["/opt/puppet/bower-puppet-api"]
  }

  file { "/opt/puppet/bower-puppet-api/package.json":
    source => "puppet:///modules/bower_puppet_server/opt/puppet/bower-puppet-api/package.json",
    mode => 0744,
    owner => "puppet",
    group => "puppet",
    require => File["/opt/puppet/bower-puppet-api"]
  }
}
