users::account { 'bob':
  ensure               => present,
  allowdupe            => false,
  comment              => "Test user",
  expiry               => '3000-01-01',
  forcelocal           => false,
  gid                  => 10001,
  home                 => '/home/bob',
  managehome           => true,
  password             => '*',
  password_max_age     => 100,
  password_min_age     => 1,
  purge_ssh_keys       => true,
  system               => false,
  uid                  => 10001,
  authorized_keys      => {
    'test-dsa-key' => {
      type => 'dsa',
      key  => 'AAAAB3NzaC1kc3MAAACBAK+LNkLwR9asdfvkasdgoasifjlrj13498uygne9v8puq3prt219Ru6gzRYSThHe3nvFzPra6FV4TUNilJxVsl7YmfxjwQzuJ8WTjiQph1EHR1eN3MKkqSW4aQGRglM8JERHeubW1gwgA9d9JDVRL/13v7tVdeI12cI4pPPBxbzpAAAAFQDZyxa7D5HwETCj47quFN7OIZjVswAAAIAWtr5CLNRY4N5kVs8muit2D7rcTcgWCBghjmaSc3bSloaFk0SKlPSZkQ/HqFXuF7LNjqbwScyjVzkbGZ3wEf8c3I6IDo7JduhjkKJ/mC6Sl/NCYQTgSOnFYoRPmh3caRonJX1+Yen+hep4SEcBZpkEZcOyLZYADAePgeld63R/pQAAAIBMat2sODsQi2MKP4VgfhFQsEVAcwQHpCzO9qDMEui4txblnwqDcPOCPtlKa5MDShCB13XJTFojqH2HM+heRVHrKH1VAXVA6WeQHchx/6tKHZXdCyeCPdRejL8TOQj7AAMwT3IrrURRRRRRRRRRRRRRRRRRRRRRRRRRRRR0TllWUQ==',
    },
  },
  ssh_key_pair         => {
    'test-rsa' => {
      key_name        => 'rsa',
      public_content  => 'Public_key_content',
      private_content => 'Private_key_content',
    },
  },
  config_files         => {
    '/home/bob/.bashrc' => {
      content => 'export EDITOR=vim'
    },
  },
}
