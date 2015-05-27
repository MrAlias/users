# == Type users::account
#
# Manage user account. This is an addition to the puppet built-in user type.
# It adds features to help support management of normal users in addition to
# system users.
#
# === Parameters
#
# [*ensure*]
#   The state that the account should be in. 
#
#   Valid values are `present` and `absent`.
#
# [*allowdupe*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `false`.
#
# [*attribute_membership*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `'minimum'`.
#
# [*attributes*]
#   Value passed to the puppet built-in user type.
#
# [*auth_membership*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `'minimum'`.
#
# [*auths*]
#   Value passed to the puppet built-in user type.
#
# [*comment*]
#   Value passed to the puppet built-in user type.
#
# [*expiry*]
#   Value passed to the puppet built-in user type.
#
# [*forcelocal*]
#   Value passed to the puppet built-in user type.
#
# [*gid*]
#   Value passed to the puppet built-in user type.
#
# [*groups*]
#   Value passed to the puppet built-in user type.
#
# [*home*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `"/home/${name}"`.
#
# [*ia_load_module*]
#   Value passed to the puppet built-in user type.
#
# [*iterations*]
#   Value passed to the puppet built-in user type.
#
# [*key_membership*]
#   Value passed to the puppet built-in user type.
#
# [*keys*]
#   Value passed to the puppet built-in user type.
#
# [*managehome*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `true` unlike the default for the user type.
#
# [*membership*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `'minimum'`.
#
# [*password*]
#   Value passed to the puppet built-in user type.
#
# [*password_max_age*]
#   Value passed to the puppet built-in user type.
#
# [*password_min_age*]
#   Value passed to the puppet built-in user type.
#
# [*profile_membership*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `'minimum'`.
#
# [*profiles*]
#   Value passed to the puppet built-in user type.
#
# [*project*]
#   Value passed to the puppet built-in user type.
#
# [*provider*]
#   Value passed to the puppet built-in user type.
#
# [*purge_ssh_keys*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `false`.
#
# [*role_membership*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `'minimum'`.
#
# [*roles*]
#   Value passed to the puppet built-in user type.
#
# [*salt*]
#   Value passed to the puppet built-in user type.
#
# [*shell*]
#   Value passed to the puppet built-in user type.
#
# [*system*]
#   Value passed to the puppet built-in user type.
#
#   The default value is `false`.
#
# [*uid*]
#   UID of the user the account creates.
#
# [*authorized_keys*]
#   Hash of all the SSH keys that user account will accept connections for.
#
# [*ssh_key_pair*]
#   Hash of all the public and private ssh pairs to create and manage.
#
# [*config_files*]
#   Hash of all the account config files to create and manage.
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
define users::account (
  $ensure               = present,
  $allowdupe            = false,
  $attribute_membership = 'minimum',
  $attributes           = undef,
  $auth_membership      = 'minimum',
  $auths                = undef,
  $comment              = undef,
  $expiry               = undef,
  $forcelocal           = undef,
  $gid                  = undef,
  $groups               = undef,
  $home                 = "/home/${name}",
  $ia_load_module       = undef,
  $iterations           = undef,
  $key_membership       = undef,
  $keys                 = undef,
  $managehome           = true,
  $membership           = 'minimum',
  $password             = undef,
  $password_max_age     = undef,
  $password_min_age     = undef,
  $profile_membership   = 'minimum',
  $profiles             = undef,
  $project              = undef,
  $provider             = undef,
  $purge_ssh_keys       = false,
  $role_membership      = 'minimum',
  $roles                = undef,
  $salt                 = undef,
  $shell                = undef,
  $system               = false,
  $uid                  = undef,
  $authorized_keys      = undef,
  $ssh_key_pair         = undef,
  $config_files         = undef,
  $packages             = [],
) {
  if $packages {
    ensure_packages($packages, {'before' => User[$name]})
  }

  user { $name:
    ensure               => $ensure,
    allowdupe            => $allowdupe,
    attribute_membership => $attribute_membership,
    attributes           => $attributes,
    auth_membership      => $auth_membership,
    auths                => $auths,
    comment              => $comment,
    expiry               => $expiry,
    forcelocal           => $forcelocal,
    gid                  => $gid,
    groups               => $groups,
    home                 => $home,
    ia_load_module       => $ia_load_module,
    iterations           => $iterations,
    key_membership       => $key_membership,
    keys                 => $keys,
    managehome           => $managehome,
    membership           => $membership,
    password             => $password,
    password_max_age     => $password_max_age,
    password_min_age     => $password_min_age,
    profile_membership   => $profile_membership,
    profiles             => $profiles,
    project              => $project,
    provider             => $provider,
    purge_ssh_keys       => $purge_ssh_keys,
    role_membership      => $role_membership,
    roles                => $roles,
    salt                 => $salt,
    shell                => $shell,
    system               => $system,
    uid                  => $uid,
  }

  # Create the user home directory if specified and told to.
  if ($home and $managehome) {
    $home_attributes = {
      'ensure'  => 'directory',
      'mode'    => '0755',
      'owner'   => $name,
      'group'   => $gid,
      'require' => User[$name],
    }

    ensure_resource('file', $home, $home_attributes)
  }

  if $authorized_keys {
    $auth_keys_defaults = {
      ensure  => $ensure,
      user    => $name,
      require => User[$name],
    }

    create_resources(ssh_authorized_key, $authorized_keys, $auth_keys_defaults)
  }

  if $ssh_key_pair {
    $ssh_key_pair_defaults = {
      ensure  => $ensure,
      user    => $name,
      group   => $gid,
      home    => $home,
      require => User[$name],
    }

    create_resources(ssh_key_pair, $ssh_key_pair, $ssh_key_pair_defaults)
  }

  if $config_files {
    $config_file_defaults = {
      ensure  => $ensure,
      owner   => $name,
      group   => $gid,
      require => User[$name],
    }

    create_resources(file, $config_files, $config_file_defaults)
  }
}
