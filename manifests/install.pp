# == Class puppet_installer::install
#
class puppet_installer::install {
  $wwwroot = "${::puppet_installer::www_root}/www"
  $puppet_master_fqdn = $::puppet_installer::params::master

  validate_absolute_path($wwwroot)
  validate_string($puppet_master_fqdn)

  file { [$wwwroot, "${wwwroot}/deploy"]:
    ensure => 'directory',
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { "${wwwroot}/deploy/agent.sh":
    ensure  => present,
    content => template('puppet_installer/install_puppet.sh.erb'),
    owner   => 'puppet',
    group   => 'www-data',
    require => File["${wwwroot}/deploy"],
  }
}
