# == Class: bootstrap
#
# Deploy a curl | bash puppet install script
# to help bootstrap infrastructure
#
# === Parameters
#
# [master]
#   master that will be contacted by the bootstrap script (defaults to fqdn)
#
# [manage_vhosts]
#   Configure the webserver. Defaults to true. Set to false if you want to
#   configure the vhost some other way and just want this to template out
#   the install script.
#
# [webserver]
#   Set to "apache" or "nginx"; requires jfryman/nginx or puppetlabs/apache
#
# [www_root]
#   Location where the bootstrap script(s) will live. Defaults to $confdir/www
#
# [vhost_domain]
#   fqdn for the vhost, if managed. Defaults to fqdn.
class bootstrap (
  $master           = $::bootstrap::params::master,
  $manage_vhosts    = true,
  $webserver        = $::bootstrap::params::webserver,
  $www_root         = $::bootstrap::params::www_root,
  $vhost_domain     = $::fqdn,
  $ssl_cert         = undef,
  $ssl_key          = undef,
) inherits ::bootstrap::params {
  validate_bool($manage_vhosts)

  include ::bootstrap::install

  if $manage_vhosts {
    validate_absolute_path($ssl_cert)
    validate_absolute_path($ssl_key)
    include ::bootstrap::config
  }
}
