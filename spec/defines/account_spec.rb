require 'spec_helper'

describe 'users::account', :type => 'define' do
  context 'runs with default params and content' do
    let(:title) { 'alice' }

    it { should compile.with_all_deps }
    it { should contain_users__account('alice') }
    it { should contain_user('alice').with({
      :ensure               => 'present',
      :allowdupe            => false,
      :attribute_membership => 'minimum',
      :auth_membership      => 'minimum',
      :home                 => '/home/alice',
      :managehome           => true,
      :membership           => 'minimum',
      :profile_membership   => 'minimum',
      :purge_ssh_keys       => false,
      :role_membership      => 'minimum',
      :system               => false,
    }) }
    it { should contain_file('/home/alice').with({
      :ensure => 'directory',
      :mode   => '0755',
      :owner  => 'alice',
    }).that_requires('User[alice]') }
  end

  context 'setting ensure to absent removes user correctly' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :ensure     => 'absent',
        :managehome => true,
      }
    }

    it { should contain_user('alice').with({
      :ensure               => 'absent',
      :managehome           => true,
    }) }
    it { should contain_file('/home/alice').with({
      :ensure => 'absent',
    }) }
  end
end
