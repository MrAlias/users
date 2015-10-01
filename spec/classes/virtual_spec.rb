require 'spec_helper'

describe 'users::virtual', :type => 'class' do
  context 'with defaults for all parameters' do
    it { should compile.with_all_deps }
    it { should contain_class('users::virtual') }
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

    let :pre_condition do
      'Users::Account <| |>'
    end

    it { should compile.with_all_deps }
    it { should contain_class('users::virtual') }
    it { should contain_file('/home/bob') }
    it { should contain_users__account('alice').with_ensure('absent') }
    it { should contain_users__account('bob').with_ensure('present') }
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
