class nodejs {
  yumrepo { "epel":
      baseurl => "http://download.fedoraproject.org/pub/epel/6/\$basearch",
      descr => "EPEL repo",
      enabled => 1,
      gpgcheck => 0,
  }

  package { 'npm':
    ensure => installed,
    require => Yumrepo['epel']
  }
}
