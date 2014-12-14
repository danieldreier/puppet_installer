# == Class puppet_installer::config
#
# This class is called from puppet_installer
#
class puppet_installer::config {
  case $::puppet_installer::webserver {
    'apache':  { include ::puppet_installer::config::apache }
    'nginx':   { include ::puppet_installer::config::nginx }
    'none':    { }
    default:   { fail("unknown webserver:  ${::puppet_installer::webserver}") }
  }
}
