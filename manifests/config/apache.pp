# == Class puppet_installer::config::apache
#
# Configure an apache vhost
#
class puppet_installer::config::apache {
  if $::puppet_installer::manage_webserver == true {
    include apache
  }

  apache::vhost { $::puppet_installer::vhost_domain:
    port             => '443',
    docroot          => "${::puppet_installer::www_root}/www/deploy",
    fallbackresource => '/agent.sh',
    ssl              => true,
    ssl_cert         => $::puppet_installer::ssl_cert,
    ssl_key          => $::puppet_installer::ssl_key,
  }
}
