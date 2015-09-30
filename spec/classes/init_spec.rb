require 'spec_helper'

describe 'users', :type => 'class' do
  context 'with defaults for all parameters' do
    it { should compile.with_all_deps }
    it { should contain_class('users') }
  end

  context 'with users passed as hash' do
    let(:params) do
      {
        :hash => {
          'alice' =>  { 'ensure' => 'absent' },
          'bob'   =>  { 'ensure' => 'present' },
        }
      }
    end

    it { should compile.with_all_deps }
    it { should contain_class('users') }
    it { should contain_file('/home/bob') }
    it { should contain_users__account('alice').with({:ensure => 'absent'}) }
    it { should contain_users__account('bob').with({:ensure => 'present'}) }
  end

  context 'with bad parameter for hash' do
    let(:params) do
      {
        :hash => 'fail'
      }
    end

    it { should compile.and_raise_error(/\"fail\" is not a Hash/) }
  end
end
