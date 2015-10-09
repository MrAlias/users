# users

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What users affects](#what-users-affects)
    * [Beginning with users](#beginning-with-users)
3. [Usage](#usage)
4. [Reference](#reference)
    * [Classes](#classes)
    * [Defined Types](#defined-types)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

This module offers comprehensive user management.  It is designed to provide a single interface for common user management tasks.  So far this includes:

* SSH authorized key management.
* SSH public and private key management.
* User specific configuration file management.
* User related packages installation.

The module is designed with the flexibility to define users in multiple ways:

* Individually, by defining `users:account` resources.
* Collectively, by passing all users and settings as a hash.  This can be accomplish in multiple ways:
    * Simply passing the users hash to the main `users` class will immediately instantiate the users accounts.
    * Passing the users hash to the `users::virtual` class will create virtual users accounts that can then be realized in other parts of your project.
    * Defining the users hash (either virtually or not) in Hiera.

## Setup

### What users affects

* Users on the system.
* Packages on the system.
* User home directories and files.
    * User SSH directories and files.
    * User configuration files.

### Beginning with users

To start managing a systems users:

```puppet
class { 'users':
  hash => {
    'alice' => { 'ensure' => 'present' },
    'bob'   => { 'ensure' => 'present' },
  },
}
```

## Usage

### Create custom users

The full capability of the built-in puppet `user` resource are accessible, which mean you can create as complex of users as you could with the original resource.

```puppet
class { 'users':
  hash => {
    'alice' => {
      'ensure'           => 'present',
      'allowdupe'        => true,
      'comment'          => 'Alice from accounting',
      'expiry'           => '3000-01-01',
      'forcelocal'       => false,
      'uid'              => 10001,
      'gid'              => 10001,
      'home'             => '/mnt/homes/alice',
      'managehome'       => true,
      'password'         => '*',
      'password_max_age' => 100,
      'password_min_age' => 1,
      'purge_ssh_keys'   => true,
    },
    'timer'   => {
      'ensure'          => 'present'
      'comment'         => 'Custom time keeper',
      'uid'             => 672,
      'gid'             => 672,
      'home'            => '/var/timer',
      'managehome'      => true,
      'purge_ssh_keys'  => true,
      'shell'           => '/usr/sbin/nologin',
      'system'          => true,
    },
  }
}
```

### Create multiple users in different states

Users can be defined as `present` or `absent`, the same way the native puppet resource allows.

```puppet
class { 'users':
  hash => {
    'alice' => { 'ensure' => 'present' },
    'bob'   => { 'ensure' => 'present' },
    'carl'  => { 'ensure' => 'absent' },
  }
}
```

This will ensure that `alice` and `bob` exist, but `carl` and all of his belongings (i.e. home directory, SSH keys, config files, ...) are removed.

### Create multiple virtual users

Just like with the native puppet resource, users can be created as virtual resources.  This allows you to only realize the users that you need on specific nodes.

```puppet
class { 'users::virtual':
  hash => {
    'alice' => { 'ensure' => 'present' },
    'bob'   => { 'ensure' => 'present' },
  }
}
```

### Create user with custom GID and UID

In addition to being able to define a user's GID like the native puppet resource, this module will automatically ensure that the group exists before instantiating the user.

```puppet
class { 'users':
  hash => {
    'alice' => {
      'ensure' => 'present'
      'uid'    => 12345,
      'gid'    => 12345,
    },
  }
}
```

This will create a user `alice` with UID `12345` and GID `12345`, but before it does so it will make sure that there is a group named `alice` with GID `12345`.

### Create user and setup SSH authorized keys

A common user management task is to ensure a user has the correct SSH access.

```puppet
class { 'users':
  hash => {
    'alice' => {
      'authorized_keys'  => {
        'work-dsa-key' => {
          'type' => 'dsa',
          'key'  => 'WORKDSAPUBLICKEY',
        },
        'home-rsa-key' => {
          'type' => 'rsa',
          'key'  => 'HOMERSAPUBLICKEY',
        },
      },
    },
  }
}
```

This example ensures that the `alice` user has both her home and work SSH keys setup on the system so she can access it remotely.

### Create user and setup SSH private and public key pairs

There are cases where certain users need SSH keys installed on the remote system.  In this case it is a better idea to define them in hiera and use an encrytion method (i.e. using the [hiera-eyaml](https://github.com/TomPoulton/hiera-eyaml) gem).

```yaml
---
...
users::hash:
  alice:
    ...
    ssh_key_pair:
      dev-rsa:
        key_name: 'rsa'
        public_content: 'PUBLICKEYCONTENT'
        private_content: ENC[PKCS7,ENCRYPTEDPUBLICKEYCONTENT...]
```

### Adding packages for a particular user

Some times users can be particular in what packages they will need.  Each user definition allows for custom packages to be installed for that user.

```puppet
class { 'users':
  hash => {
    'alice' => { 'packages' => ['tmux', 'less'] },
    'bob'   => { 'packages' => ['screen', 'more'] },
  }
}
```

### Setting up configuration files for users

Configuration files can be defined as a normal puppet `file` resource would be.

```puppet
class { 'users':
  hash => {
    'alice' => {
      'packages' => ['tmux', 'less']
      'config_files' => {
        '/home/alice/.tmuxrc' => {
          'content' => 'set-window-option -g xterm-keys on'
        },
        '/home/alice/.lessrc' => {
          'content' => '-RS'
        },
      },
    },
  }
}
```

## Reference

### Classes

#### users

Creates all the specified user accounts using the `users::account` resource.

##### `users::hash`

Hash of all user accounts. Each user should be a key and all corresponding account values are the associated hash value.

#### users::virtual

Defines all the specified virtual user accounts using the `users::acount` resource.

##### `users::virtual::hash`

Hash of all virtual user accounts. Each virtual user should be a key and all corresponding account values are the associated hash value.

### Defined Types

#### users::account

Creates a customized user account that expands upon the built-in puppet `user` type.

##### `users::account::ensure`

   The state that the account should be in. 

   Valid values are `present` and `absent`.

##### `users::account::allowdupe`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `users::account::attribute_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `users::account::attributes`

   Value passed to the puppet built-in user type.

##### `users::account::auth_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `users::account::auths`

   Value passed to the puppet built-in user type.

##### `users::account::comment`

   Value passed to the puppet built-in user type.

##### `users::account::expiry`

   Value passed to the puppet built-in user type.

##### `users::account::forcelocal`

   Value passed to the puppet built-in user type.

##### `users::account::gid`

   Value passed to the puppet built-in user type.

##### `users::account::groups`

   Value passed to the puppet built-in user type.

##### `users::account::home`

   Value passed to the puppet built-in user type.

   The default value is `"/home/${name}"`.

##### `users::account::ia_load_module`

   Value passed to the puppet built-in user type.

##### `users::account::iterations`

   Value passed to the puppet built-in user type.

##### `users::account::key_membership`

   Value passed to the puppet built-in user type.

##### `users::account::keys`

   Value passed to the puppet built-in user type.

##### `users::account::managehome`

   Value passed to the puppet built-in user type.

   The default value is `true` unlike the default for the user type.

##### `users::account::membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `users::account::password`

   Value passed to the puppet built-in user type.

##### `users::account::password_max_age`

   Value passed to the puppet built-in user type.

##### `users::account::password_min_age`

   Value passed to the puppet built-in user type.

##### `users::account::profile_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `users::account::profiles`

   Value passed to the puppet built-in user type.

##### `users::account::project`

   Value passed to the puppet built-in user type.

##### `users::account::provider`

   Value passed to the puppet built-in user type.

##### `users::account::purge_ssh_keys`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `users::account::role_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `users::account::roles`

   Value passed to the puppet built-in user type.

##### `users::account::salt`

   Value passed to the puppet built-in user type.

##### `users::account::shell`

   Value passed to the puppet built-in user type.

##### `users::account::system`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `users::account::uid`

   UID of the user the account creates.

##### `users::account::authorized_keys`

   Hash of all the SSH keys that user account will accept connections for.

##### `users::account::ssh_key_pair`

   Hash of all the public and private ssh pairs to create and manage.

##### `users::account::config_files`

   Hash of all the account config files to create and manage.

##### `users::account::packages`

  Array of all user needed packages to ensure are installed.


#### users::ssh\_key\_pair

Creates SSH keys for authentication.

##### `users::ssh_key_pair::user`

 The existing user account in which the SSH key pair will be installed.  The user will be autorequired if managed by a `user` resource.

##### `users::ssh_key_pair::home`

 Home directory of the `user` where the .ssh directory for the SSH key pair to be installed in exists.

 Default value is `'/home/$user'`.

##### `users::ssh_key_pair::key_name`

 (*Namevar*: If omitted, the value of this attribute defaults to the resource's title)

 Base name of the key pair.  The private key will have this name and the public key will have a suffix of .pub appended to this.

##### `users::ssh_key_pair::ensure`

 Set the state of the key pair on the system.

 Default value is `present`.

##### `users::ssh_key_pair::group`

 Group that will own of the key pair files.

##### `users::ssh_key_pair::private_source`

 The puppet URI locating the private ssh key file. This cannot be defined along with `private_content`.

##### `users::ssh_key_pair::private_content`

 The contents of the private ssh key file. This cannot be defined along with `private_source`.

##### `users::ssh_key_pair::public_source`

 The puppet URI locating the public ssh key file. This cannot be defined along with `public_content`.

##### `users::ssh_key_pair::public_content`

 The contents of the public ssh key file. This cannot be defined along with `public_source`.

## Limitations

This module currently only receives testing on the following operating systems:

* Debian (5,6,7)
* Ubuntu (12.04,14.04)
* CentOS (5,6,7)

This module will likely work on many other Linux distributions, but no grantees are made.

## Development

See [CONTRIBUTING.md](https://github.com/MrAlias/users/blob/master/CONTRIBUTING.md)
