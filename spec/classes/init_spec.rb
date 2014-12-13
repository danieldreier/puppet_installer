require 'spec_helper'

describe 'bootstrap' do
  context 'supported operating systems' do
    PuppetSpecFacts.facts_for_platform_by_fact(select_facts: {'lsbdistid' => 'CentOS',
                                                              'architecture' => 'x86_64',
                                                              'is_pe' => 'true',
                                                              'fact_style' => 'stringified'}) do |name, facthash|
      describe "bootstrap class without any parameters on #{name}" do
        let(:params) {{
          :master           => 'puppetmaster.example.com',
          :manage_webserver => true,
          :webserver        => 'nginx',
          :www_root         => '/etc/puppet/www',
          :ssl_cert         => "/etc/ssl/certs/server.pem",
          :ssl_key          => "/etc/ssl/private_keys/server.pem",
          }}
        let(:facts) { facthash }

        it { should compile.with_all_deps }

        it { should contain_class('bootstrap::params') }
        it { should contain_class('bootstrap::install') }
      end
    end
  end

end
