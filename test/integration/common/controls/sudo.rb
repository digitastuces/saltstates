# frozen_string_literal: true

control 'common.sudo' do
  title 'Test Sudo installation'

  # Test Sudo package
  describe package('sudo') do
    it { should be_installed }
  end

  # Test /etc/sudoers.d clean
  describe file('/etc/sudoers.d/README') do
    it { should_not exist }
  end
end
