# frozen_string_literal: true

salt_version = input('pillar').dig('digitastuces', 'servers', 'salt', 'package_version') || []

control 'common.salt' do
  title 'Test Salt installation'

  # Test Salt package
  describe package('salt-minion') do
    it { should be_installed }
    its('version') { should eq salt_version }
  end
end
