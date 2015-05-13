# == Type users::ssh_key_pair
#
# Manage user account SSH private and public key pairs.
#
# === Parameters
#
# [*user*]
#   The existing user account in which the SSH key pair will be installed. 
#   The user will be autorequired if managed by a `user` resource.
#
# [*home*]
#   Home directory of the `user` where the .ssh directory for the SSH key pair
#   to be installed in exists.
#
#   Default value is `'/home/$user'`.
#
# [*key_name*]
#   (*Namevar*: If omitted, this attribute's value defaults to the resource's
#   title)
#
#   Base name of the key pair.  The private key will have this name and the
#   public key will have a suffix of .pub appended to this.
#
# [*ensure*]
#   Set the state of the key pair on the system.
#
#   Default value is `present`.
#
# [*group*]
#   Group that will own of the key pair files.
#
# [*private_source*]
#   The puppet URI locating the private ssh key file. This cannot be defined
#   along with private_content.
#
# [*private_content*]
#   The contents of the private ssh key file. This cannot be defined along with
#   private_source.
#
# [*public_source*]
#   The puppet URI locating the public ssh key file. This cannot be defined
#   along with public_content.
#
# [*public_content*]
#   The contents of the public ssh key file. This cannot be defined along with
#   public_source.
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
define users::ssh_key_pair (
  $user,
  $home            = undef,
  $key_name        = $title,
  $ensure          = present,
  $group           = undef,
  $private_source  = undef,
  $private_content = undef,
  $public_source   = undef,
  $public_content  = undef,
) {
  $_home = $home ? {
    undef   => "/home/${user}",
    default => $home
  }

  # Ensure a .ssh directory is created.
  if ! defined_with_params(File["${_home}/.ssh/"], {'ensure' => 'directory'}) {
    # Autorequire User[$user] if the resource is defined.
    if defined(User[$user]) {
      $_require = [User[$user], File["${_home}/.ssh/"]]
      $ssh_dir_defaults = {
        'ensure'  => 'directory',
        'mode'    => '0700',
        'owner'   => $user,
        'group'   => $group,
        'require' => User[$user],
      }
    } else {
      $_require = File["${_home}/.ssh/"]
      $ssh_dir_defaults = {
        'ensure'  => 'directory',
        'mode'    => '0700',
        'owner'   => $user,
        'group'   => $group,
      }
    }

    ensure_resource('file', "${_home}/.ssh/", $ssh_dir_defaults)
  }

  file { "${_home}/.ssh/${key_name}":
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    mode    => '0600',
    source  => $private_source,
    content => $private_content,
    require => $_require,
  }

  file { "${_home}/.ssh/${key_name}.pub":
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    source  => $public_source,
    content => $public_content,
    require => $_require,
  }
}
