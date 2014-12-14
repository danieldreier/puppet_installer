# == Class: puppet_installer
#
# Deploy a curl | bash puppet install script
# to help puppet_installer infrastructure
#
# === Parameters
#
# [master]
#   master that will be contacted by the puppet_installer script (defaults to fqdn)
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
#   Location where the puppet_installer script(s) will live. Defaults to $confdir/www
#
# [vhost_domain]
#   fqdn for the vhost, if managed. Defaults to fqdn.
class puppet_installer (
  $master           = $::puppet_installer::params::master,
  $manage_vhosts    = true,
  $webserver        = $::puppet_installer::params::webserver,
  $www_root         = $::puppet_installer::params::www_root,
  $vhost_domain     = $::fqdn,
  $ssl_cert         = undef,
  $ssl_key          = undef,
) inherits ::puppet_installer::params {
  validate_bool($manage_vhosts)

  include ::puppet_installer::install

  if $manage_vhosts {
    validate_absolute_path($ssl_cert)
    validate_absolute_path($ssl_key)
    include ::puppet_installer::config
  }
}
