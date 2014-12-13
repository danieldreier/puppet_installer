# == Class bootstrap::config::apache
#
# Configure an apache vhost
#
class bootstrap::config::apache {
  if $::bootstrap::manage_webserver == true {
    include apache
  }

  apache::vhost { $::bootstrap::vhost_domain:
    port             => '443',
    docroot          => "${::bootstrap::www_root}/www/deploy",
    fallbackresource => '/agent.sh',
    ssl              => true,
    ssl_cert         => $::bootstrap::ssl_cert,
    ssl_key          => $::bootstrap::ssl_key,
  }
}
