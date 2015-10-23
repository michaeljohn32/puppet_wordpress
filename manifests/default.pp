stage{'first':
  before => Stage['main']
}
$packages=[
  'debian-keyring',
  'gedit',
  'vim',
]

package{$packages:
  ensure => installed,
}
class{ 'apt-debian':
  stage   => first,
  release => 'wheezy',
}
include wordpress
exec{'/bin/chmod -R 755 /opt/wordpress/wp-content': } 
Class['wordpress'] -> Exec['/bin/chmod -R 755 /opt/wordpress/wp-content'] 


