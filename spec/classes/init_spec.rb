require 'spec_helper'

describe 'puppet_installer' do
  PuppetSpecFacts.facts_for_platform_by_fact(select_facts: {
    "kernel" => "Linux",
    "operatingsystem" => "Debian",
    "lsbdistrelease" => "7.7",
    "puppetversion" => "3.7.2"
  }).each do |name,facthash|
    ['apache','nginx'].each do |webserver|
      describe "basic compile on #{name} using #{webserver}" do
        let :pre_condition do
          "include ::#{webserver}"
        end
        let(:params) {{
          :master        => 'puppetmaster.example.com',
          :manage_vhosts => true,
          :webserver     => webserver,
          :www_root      => '/etc/puppet/www',
          :ssl_cert      => "/etc/ssl/certs/server.pem",
          :ssl_key       => "/etc/ssl/private_keys/server.pem",
          }}
        let(:facts) { facthash }

        it { should compile.with_all_deps }

        it { should contain_class('puppet_installer::params') }
        #it { should contain_class('puppet_installer::install') }
        #it { should contain_class('puppet_installer::config') }
      end
    end
  end
end
