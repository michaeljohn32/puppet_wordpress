# Install mysql server and set up wordpress database
class wordpress::db($root_password='changemechangeme223') {

  class { '::mysql::server':
    root_password   => $root_password,
  }
  mysql::db{ $wordpress::db_name:
    user     => $wordpress::db_user,
    password => $wordpress::db_password,
    host     => 'localhost',
    grant    => ['ALL'],
  }
}
