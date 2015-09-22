# -*- mode: ruby -*-
# vi: set ft=ruby :

class postgresql::install {

  # Update the packages apt
  exec { "apt-update-postgresql":
    command => "/usr/bin/apt-get update",
  }

  package {["postgresql", "postgresql-contrib", "libpq-dev"]:
    ensure  => installed,
    require => Exec["apt-update-postgresql"]
  }

}
