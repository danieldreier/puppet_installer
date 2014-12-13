# == Class bootstrap::config
#
# This class is called from bootstrap
#
class bootstrap::config {
  case $::bootstrap::webserver {
    'apache':  { include ::bootstrap::config::apache }
    'nginx':   { include ::bootstrap::config::nginx }
    'none':    { }
    default:   { fail("unknown webserver:  ${::bootstrap::webserver}") }
  }
}
