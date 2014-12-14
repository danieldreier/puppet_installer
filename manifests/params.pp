# == Class puppet_installer::params
#
# This class is meant to be called from puppet_installer
#
class puppet_installer::params {
  $master           = $::fqdn
  $webserver        = 'nginx'
  $www_root         = "${::confdir}/www"
}
