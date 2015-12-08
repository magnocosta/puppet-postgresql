# -*- mode: ruby -*-
# vi: set ft=ruby :

class postgresql::install {

  file { "/var/opt/keys":
    ensure   => "directory",
    owner    =>  root,
    group    =>  root,
    require  =>  Class["common::basic"]
  }

  # Config key
  file { "/var/opt/keys/ACCC4CF8.key":
    owner    =>  root,
    group    =>  root,
    content  =>  template("postgresql/ACCC4CF8.key"),
    require  =>  File["/var/opt/keys"]
  }

  exec {"get-postgresql-key":
    command => "/usr/bin/apt-key add /var/opt/keys/ACCC4CF8.key",
    require => File["/var/opt/keys/ACCC4CF8.key"]
  }

  # Config postgresql repo
  file { "/etc/apt/sources.list.d/postgresql.list":
    owner    =>  root,
    group    =>  root,
    mode     =>  644,
    content  =>  template("postgresql/postgresql.list"),
    require  =>  Exec['get-postgresql-key']
  }

  exec { "apt-update-postgresql":
    command => "/usr/bin/apt-get update -y -q",
    timeout => 0,
    require => File["/etc/apt/sources.list.d/postgresql.list"]
  }

  package {["postgresql", "postgresql-contrib", "libpq-dev"]:
    ensure  => installed,
    require => Exec["apt-update-postgresql"]
  }

}
