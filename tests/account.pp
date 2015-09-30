users::account { 'bob':
  ensure           => present,
  allowdupe        => false,
  comment          => 'Test user',
  expiry           => '3000-01-01',
  forcelocal       => false,
  gid              => 10001,
  home             => '/home/bob',
  managehome       => true,
  password         => '*',
  password_max_age => 100,
  password_min_age => 1,
  purge_ssh_keys   => true,
  system           => false,
  uid              => 10001,
  authorized_keys  => {
    'test-dsa-key' => {
      'type' => 'dsa',
      'key'  => 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBCDEFGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGHIJKLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLMNOPQRSTUUUVVVVVVVVVVVVVVVVVVVVVVVVVVWXYZZZZZZZZZ',
    },
  },
  ssh_key_pair     => {
    'test-rsa' => {
      'key_name'        => 'rsa',
      'public_content'  => 'Public_key_content',
      'private_content' => 'Private_key_content',
    },
  },
  config_files     => {
    '/home/bob/.bashrc' => {
      'content' => 'export EDITOR=vim'
    },
  },
}
