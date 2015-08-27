require 'spec_helper_acceptance'

pp = <<-EOS
class { 'users':
  hash => {
    bob => {
    'ensure' => 'present',
    'uid'    => '10001',
    },
  },
}
EOS

describe 'users', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'Success' do
    it 'Should run without errors' do
      apply_manifest(pp, :catch_failures => true)
    end

    it 'Should be idempotent' do
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
