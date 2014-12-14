# == Class puppet_installer::config::nginx
#
# Configure an nginx vhost
#
class puppet_installer::config::nginx {
  if $::puppet_installer::manage_webserver == true {
    include nginx
  }

  nginx::resource::vhost { 'deploy_script':
    server_name          => [$::puppet_installer::vhost_domain],
    ssl                  => true,
    ssl_port             => 443,
    listen_port          => 443, # force ssl_only by matching ssl_port
    ssl_cert             => $::puppet_installer::ssl_cert,
    ssl_key              => $::puppet_installer::ssl_key,
    ssl_ciphers          => 'HIGH:!aNULL:!MD5',
    ssl_protocols        => 'TLSv1.2 TLSv1.1 TLSv1',
    use_default_location => false,
  }
  nginx::resource::location { 'agent_install_script':
    ensure         => present,
    location_alias => "${::puppet_installer::www_root}/www/deploy/agent.sh",
    location       => '/deploy',
    vhost          => 'deploy_script',
    priority       => 701,
    require        => Class['::puppet_installer::install'],
  }
}
