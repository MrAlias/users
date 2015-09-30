# users

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What users affects](#what-users-affects)
    * [Beginning with users](#beginning-with-users)
4. [Usage](#usage)
5. [Reference](#reference)
    * [Classes](#classes)
    * [Defined Types](#defined-types)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Puppet module that handles user account management with support for virtual users and hiera.

## Module Description

This module is intended to be an addition to the puppet built-in user type:

* It adds features to better support management of normal users in addition to system users by implementing an account class.
* Support is provided to handle virtual user declaration, helping to keep all users across you puppet project in a consistent and easily realizable state.
* Both declaration of data by a traditional manifest as well as via hiera are both supported.

## Setup

### What users affects

* System user management files and directories.
* User home directories and files.
 * Specifically user SSH directories and files.

### Beginning with users

To use the added functionality of the module at its minimum something like this will get you started:

```puppet
users::account { 'bob':
  ssh_key_pair         => {
    'test-rsa' => {
      key_name        => 'rsa',
      public_content  => 'Public_key_content',
      private_content => 'Private_key_content',
    },
  },
}
```

## Usage

### Create multiple users

If you want to create multiple user accounts, you can supply a hash with all the values:

```puppet
class { 'users':
  hash => {
    'bob'   => { 'ensure' => 'present' },
    'sandy' => { 'ensure' => 'present' },
  }
}
```

This can also be done with hiera by adding the following to file in your hiera hierarchy:

```yaml
users::hash:
  bob:
    ensure: present
  sandy:
    ensure: present
```

Once you have your user data setup in hiera, all that is needed is to include the users class.

```puppet
class { 'users': }
```


### Create multiple virtual users

Creating virtual users allows you define users once for an entire project.

```puppet
class { 'users::virtual':
  hash => {
    'bob'   => { 'ensure' => 'present' },
    'sandy' => { 'ensure' => 'present' },
  }
}
```

Or again if you want to do this hiera:

```yaml
users::virtual::hash:
  bob:
    ensure: present
  sandy:
    ensure: present
```

Once your virtual users are setup all you need to do is realize them wherever the project requires them:

```puppet
realize( Users:Account['sandy'] )
```

## Reference

### Classes

#### users

Creates all the specified user accounts using the `users::account` resource.

##### `hash`

Hash of all user accounts. Each user should be a key and all corresponding account values are the associated hash value.

#### users::virtual

Defines all the specified virtual user accounts using the `users::acount` resource.

##### `hash`

Hash of all virtual user accounts. Each virtual user should be a key and all corresponding account values are the associated hash value.

### Defined Types

#### users::account

Creates a customized user account that expands upon the built-in puppet `user` type.

##### `ensure`

   The state that the account should be in. 

   Valid values are `present` and `absent`.

##### `allowdupe`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `attribute_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `attributes`

   Value passed to the puppet built-in user type.

##### `auth_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `auths`

   Value passed to the puppet built-in user type.

##### `comment`

   Value passed to the puppet built-in user type.

##### `expiry`

   Value passed to the puppet built-in user type.

##### `forcelocal`

   Value passed to the puppet built-in user type.

##### `gid`

   Value passed to the puppet built-in user type.

##### `groups`

   Value passed to the puppet built-in user type.

##### `home`

   Value passed to the puppet built-in user type.

   The default value is `"/home/${name}"`.

##### `ia_load_module`

   Value passed to the puppet built-in user type.

##### `iterations`

   Value passed to the puppet built-in user type.

##### `key_membership`

   Value passed to the puppet built-in user type.

##### `keys`

   Value passed to the puppet built-in user type.

##### `managehome`

   Value passed to the puppet built-in user type.

   The default value is `true` unlike the default for the user type.

##### `membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `password`

   Value passed to the puppet built-in user type.

##### `password_max_age`

   Value passed to the puppet built-in user type.

##### `password_min_age`

   Value passed to the puppet built-in user type.

##### `profile_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `profiles`

   Value passed to the puppet built-in user type.

##### `project`

   Value passed to the puppet built-in user type.

##### `provider`

   Value passed to the puppet built-in user type.

##### `purge_ssh_keys`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `role_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `roles`

   Value passed to the puppet built-in user type.

##### `salt`

   Value passed to the puppet built-in user type.

##### `shell`

   Value passed to the puppet built-in user type.

##### `system`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `uid`

   UID of the user the account creates.

##### `authorized_keys`

   Hash of all the SSH keys that user account will accept connections for.

##### `ssh_key_pair`

   Hash of all the public and private ssh pairs to create and manage.

##### `config_files`

   Hash of all the account config files to create and manage.

##### `packages`

  Array of all user needed packages to ensure are installed.


#### users::ssh\_key\_pair

Creates SSH keys for authentication.

##### `user`

 The existing user account in which the SSH key pair will be installed.  The user will be autorequired if managed by a `user` resource.

##### `home`

 Home directory of the `user` where the .ssh directory for the SSH key pair to be installed in exists.

 Default value is `'/home/$user'`.

##### `key_name`

 (*Namevar*: If omitted, this attribute's value defaults to the resource's title)

 Base name of the key pair.  The private key will have this name and the public key will have a suffix of .pub appended to this.

##### `ensure`

 Set the state of the key pair on the system.

 Default value is `present`.

##### `group`

 Group that will own of the key pair files.

##### `private_source`

 The puppet URI locating the private ssh key file. This cannot be defined along with `private_content`.

##### `private_content`

 The contents of the private ssh key file. This cannot be defined along with `private_source`.

##### `public_source`

 The puppet URI locating the public ssh key file. This cannot be defined along with `public_content`.

##### `public_content`

 The contents of the public ssh key file. This cannot be defined along with `public_source`.

## Limitations

This module has only been tested on Debian and CentOS.
