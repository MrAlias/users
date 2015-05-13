user { 'bob': ensure => present, }

file { '/home/bob': ensure => directory, }

users::ssh_key_pair { 'test-dsa':
  user            => 'bob',
  home            => '/home/bob',
  key_name        => 'demo-dsa',
  ensure          => present,
  public_content  => 'Public_key_content',
  private_content => 'Private_key_content',
}
