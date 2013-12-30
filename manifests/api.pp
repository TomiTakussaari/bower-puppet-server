class bower_puppet_server::api($root_directory="/opt") {

  file { "/etc/init.d/bower-puppet-api":
    ensure => present,
    content => template("bower_puppet_server/etc/init.d/bower-puppet-api"),
    owner => "root",
    group => "root",
    mode => 0755,
  }

  service { "bower-puppet-api":
    enable => true,
    ensure => running,
    hasrestart => false,
    hasstatus => true,
    require => [
      File["/etc/init.d/bower-puppet-api"], Package["npm"], File["$root_directory/puppet/bower-puppet-api/bower-puppet-api.js"], File["$root_directory/puppet/bower-puppet-api/package.json"]
    ]
  }

  file { ["$root_directory/puppet/bower-puppet-api"]:
    ensure => directory,
    owner => "puppet",
    group => "puppet",
    require => File["$root_directory/puppet/"]
  }

  file { "$root_directory/puppet/bower-puppet-api/bower-puppet-api.js":
    content => template("bower_puppet_server/opt/puppet/bower-puppet-api/bower-puppet-api.js"),
    mode => 0744,
    owner => "puppet",
    group => "puppet",
    require => File["$root_directory/puppet/bower-puppet-api"]
  }

  file { "$root_directory/puppet/bower-puppet-api/package.json":
    content => template("bower_puppet_server/opt/puppet/bower-puppet-api/package.json"),
    mode => 0744,
    owner => "puppet",
    group => "puppet",
    require => File["$root_directory/puppet/bower-puppet-api"]
  }
}
