# == Class bootstrap::params
#
# This class is meant to be called from bootstrap
# It sets variables according to platform
#
class bootstrap::params {
  $master           = $::fqdn
  $webserver        = 'nginx'
  $www_root         = "${::confdir}/www"
}
