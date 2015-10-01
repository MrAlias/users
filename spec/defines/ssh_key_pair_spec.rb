require 'spec_helper'

describe 'users::ssh_key_pair', :type => 'define' do
  context 'runs with generic params and content' do
    let(:title) { 'Bobs test key' }
    let(:params) do
      {
        :user            => 'bob',
        :home            => '/home/bob',
        :key_name        => 'bob_test_key',
        :ensure          => 'present',
        :group           => 'bob',
        :private_content => 'test_private_content',
        :public_content  => 'test_public_content',
      }
    end

    it { should compile.with_all_deps }
    it { should contain_users__ssh_key_pair('Bobs test key') }
    it { should contain_file('/home/bob/.ssh/').with_ensure('directory') }
    it { should contain_file('/home/bob/.ssh/bob_test_key').with({
      :ensure  => 'present',
      :owner   => 'bob',
      :group   => 'bob',
      :mode    => '0600',
      :content => 'test_private_content'
    }).that_requires('File[/home/bob/.ssh/]') }
    it { should contain_file('/home/bob/.ssh/bob_test_key.pub').with({
      :ensure  => 'present',
      :owner   => 'bob',
      :group   => 'bob',
      :mode    => '0644',
      :content => 'test_public_content'
    }).that_requires('File[/home/bob/.ssh/]') }
  end

  context 'fail if no user specified' do
    let(:title) { 'Bobs test key' }

    it { should compile.and_raise_error(/Must pass user to Users::Ssh_key_pair/) }
  end

  context 'fail if both private_content and private_source are passed' do
    let(:title) { 'Bobs test key' }
    let(:params) do
      {
        :user            => 'bob',
        :private_content => 'test_private_content',
        :private_source  => '/test_private_file',
      }
    end

    it { should compile.and_raise_error(/You cannot specify more than one of content, source, target/) }
    it { should contain_file('/home/bob/.ssh/Bobs test key') }
  end

  context 'fail if both public_content and public_source are passed' do
    let(:title) { 'Bobs test key' }
    let(:params) do
      {
        :user           => 'bob',
        :public_content => 'test_public_content',
        :public_source  => '/test_public_file',
      }
    end

    it { should compile.and_raise_error(/You cannot specify more than one of content, source, target/) }
    it { should contain_file('/home/bob/.ssh/Bobs test key.pub') }
  end
end
