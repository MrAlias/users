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

  context 'removes groups when supposed to' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :ensure => 'absent',
        :gid    => 12345,
      }
    }

    it { should contain_group('alice').with({
      :ensure => 'absent',
      :gid    => 12345,
    }).that_requires('User[alice]') }
  end

  context 'creates groups when supposed to' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :ensure => 'present',
        :gid    => 12345,
        :groups => ['admin', 'sudo'],
      }
    }

    it { should contain_group('admin').with_ensure('present').that_comes_before('User[alice]') }

    it { should contain_group('sudo').with_ensure('present').that_comes_before('User[alice]') }

    it { should contain_group('alice').with({
      :ensure => 'present',
      :gid    => 12345,
    }).that_comes_before('User[alice]') }
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

  context 'user packages are ensured to be installed' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :packages  => ['tmux'],
      }
    }

    it { should contain_package('tmux').with_ensure('present') }
  end

  context 'authorized keys are correctly setup' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :authorized_keys  => {
          'main' => {
            'type' => 'rsa',
            'key'  => 'ABC',
          }
        }
      }
    }

    it { should contain_ssh_authorized_key('main').with({
      :user => 'alice',
      :type => 'rsa',
      :key  => 'ABC',
    }) }
  end

  context 'ssh keypairs are correctly installed' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :ssh_key_pair => {
          'test' => {
            'public_content'  => 'public content',
            'private_content' => 'private content',
          }
        }
      }
    }

    it { should contain_users__ssh_key_pair('test') }
    it { should contain_file('/home/alice/.ssh/') }
    it { should contain_file('/home/alice/.ssh/test.pub') }
    it { should contain_file('/home/alice/.ssh/test') }
  end

  context 'config files are correctly installed' do
    let(:title) { 'alice' }
    let(:params) {
      {
        :config_files => {
          '/home/alice/.bashrc' => {
            'content' => 'Bashrc content'
          }
        }
      }
    }

    it { should contain_file('/home/alice/.bashrc').with_content('Bashrc content') }
  end
end
