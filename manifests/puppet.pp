class puppet($my_environment, $puppet_version, $reports_config) {
  yumrepo { "puppet-repository":
    descr =>"Puppet repository",
    baseurl => "http://yum.puppetlabs.com/el/6/products/x86_64/",
    enabled  => 1,
    gpgcheck => 1,
    gpgkey => "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs",
  }

  yumrepo { "puppet-dependencies":
    descr => "Dependencies for puppet",
    baseurl => "http://yum.puppetlabs.com/el/6/dependencies/x86_64/",
    gpgcheck => 1,
    enabled  => 1,
    gpgkey => "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs"
  }
  package { "puppet-server":
    ensure => $puppet_version,
    require => Yumrepo["puppet-repository"]
  }

  service { "puppet":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => File["/etc/puppet/puppet.conf"],
  }

  service { "puppetmaster":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => [File["/etc/puppet/puppet.conf"], Package["puppet-server"]],
  }

  file { "/etc/logrotate.d/puppet-master":
    ensure => present,
    content => template("bower_puppet_server/etc/logrotate.d/puppet-master"),
    owner => "root",
    group => "root"
  }

  file { "/etc/puppet/puppet.conf":
    ensure => present,
    content => template("bower_puppet_server/etc/puppet/puppet.conf"),
    owner => "root",
    group => "root"
  }

}
