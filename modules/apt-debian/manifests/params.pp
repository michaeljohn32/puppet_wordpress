class apt-debian::params(){
  case $::operatingsystem {
    debian: {
      $odoo_nightly_location = "http://nightly.odoo.com/8.0/nightly/deb"
      $psql_location = "http://apt.postgresql.org/pub/repos/apt/"
    }
  }
}
