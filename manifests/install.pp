# == Class bootstrap::install
#
class bootstrap::install {
  $wwwroot = "${::bootstrap::www_root}/www"
  $puppet_master_fqdn = $::bootstrap::params::master

  validate_absolute_path($wwwroot)
  validate_string($puppet_master_fqdn)

  file { [$wwwroot, "${wwwroot}/deploy"]:
    ensure => 'directory',
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { "${wwwroot}/deploy/agent.sh":
    ensure  => present,
    content => template('bootstrap/install_puppet.sh.erb'),
    owner   => 'puppet',
    group   => 'www-data',
    require => File["${wwwroot}/deploy"],
  }
}
