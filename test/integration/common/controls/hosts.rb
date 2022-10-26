# frozen_string_literal: true

fqdn              = input('pillar').dig('FBConfig', 'fqdn') || 'localhost'
hostname, *domain = fqdn.split('.')
domain            = domain.join('.')

fake_dns_enabled = input('pillar').dig('FBConfig', 'fake_dns', 'enabled')
fake_address = input('pillar').dig('FBConfig', 'fake_dns', 'address')
fake_hosts = input('pillar').dig('FBConfig', 'fake_dns', 'hosts')

static_hosts_enabled = input('pillar').dig('FBConfig', 'static_hosts', 'enabled')
static_hosts = input('pillar').dig('FBConfig', 'static_hosts', 'hosts')

map_127_0_0_1_to_hostname = input('pillar').dig('FBConfig', 'map_127_0_0_1_to_hostname')

control 'common.hosts' do
  title 'Test Hosts file installation'

  describe file('/etc/hosts') do
    it { should exist }
    if map_127_0_0_1_to_hostname
      its('content') { should match(/127.0.0.1\s.*?#{fqdn} #{hostname}/) }
    end

    if fake_dns_enabled || static_hosts_enabled
      static_hosts.each do |name, ip|
        its('content') { should match(/#{ip}\s.*?#{name}/) }
      end
    end

    if fake_dns_enabled
      fake_hosts.each do |name|
        its('content') { should match(/#{fake_address}\s.*?#{name}/) }
      end
    end
  end

  describe command('hostname -f') do
    its('stdout') { should eq "#{fqdn}\n" }
  end

  describe command('hostname -d') do
    its('stdout') { should eq "#{domain}\n" }
  end
end
