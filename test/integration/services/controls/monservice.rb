# frozen_string_literal: true

services = input('pillar').dig('DAConfig', 'services') || []


control 'services.monservice' do
  title 'Test monservice installation'

  if services.include? 'monservice'

    ['saltstates', 'saltconfig'].each do |dir|
      describe file("/srv/#{dir}") do
        it { should be_directory }
        its('owner') { should eq 'salt' }
        its('group') { should eq 'users' }
        its('mode')  { should cmp '0755' }
      end
    end

    describe file('/var/log/salt') do
      it { should be_directory }
      its('owner') { should eq 'root'}
      its('group') { should eq 'DAdeploy'}
      its('mode') { should cmp '0770' }
    end

    ['master', 'minion', 'api'].each do |file|
      describe file("/var/log/salt/#{file}") do
        it { should be_file }
        its('owner') { should eq 'root'}
        its('mode') { should cmp '0660' }
      end
    end

    # Services
    common_services = %w[salt-master salt-api]
    common_services.each do |common_service|
      describe service(common_service) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end

    # configuration
    describe file('/etc/salt/master') do
      it { should_not be_file }
    end
  end
end
