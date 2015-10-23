include params
class apt-debian::config ($proxyhost = undef, $proxyport = undef, $release, $allow_unsigned_repos = false, $odoo = false, $mainserver, $psql_repo = false, $vagrant_repo = false,$virtualbox_repo = false) {

  case $::operatingsystem {
    debian: {
      $supported = true
    }
    default: {
      $supported = false
      notify { "${module_name}_unsupported":
        message => "The ${module_name} module is not supported on ${::operatingsystem}",
      }
    }
  }

  if ($supported == true) {
    if($proxyhost == undef){
      class { 'apt':
        purge => {'sources.list' => true,'sources.list.d' => true},
      }
    }
    else {
      class { 'apt':
        proxy_host         => $proxyhost,
        proxy_port         => $proxyport,
        purge => {'sources.list' => true,'sources.list.d' => true},
      }
    }
    $bpserver  = 'http://backports.debian.org'
    $secserver = 'http://security.debian.org'
    apt::source { 'debian_main':
      location          => $mainserver,
      repos             => 'main contrib non-free',
    }
    if ($allow_unsigned_repos == true) {
      #If the packages are unsigned, we may have to do this.
      file { '/etc/apt/apt.conf.d/99auth':
        ensure  => file,
        content => "APT::Get::AllowUnauthenticated yes;",
      }
    }
    apt::source { 'debian_security':
      location          => $secserver,
      release           => "$::lsbdistcodename/updates",
      repos             => 'main contrib non-free',
    }
    if($::lsbdistcodename == 'squeeze'){
      apt::source { 'squeeze-lts':
        location   => $mainserver,
        release    => "${::lsbdistcodename}-lts",
        repos      => "main contrib non-free",
      }
#      apt::source { 'debian_backports':
#        location   => $bpserver,
#        repos      => "${::lsbdistcodename}-backports main"
#      }
      apt::pin{ 'oldoldstable': 
        release  => 'oldoldstable',
        priority => '500',
      }
    }
    elsif ($::lsbdistcodename == 'wheezy'){
      apt::pin{ 'oldstable': 
        release  => 'oldstable',
        priority => '900',
      }
      apt::pin{ 'stable': 
        ensure   => absent,
      }
      @apt::source{'odoo_deb_source':
        comment     => 'This is the Odoo Source location',
        location    => "http://nightly.odoo.com/8.0/nightly/deb", #$::apt-debian::params::odoo_nightly_location,
        release     => './',
        repos       => '',
        include_src => false,
      }
      if($psql_repo == true){
        apt::source{'postgres_deb_source':
          comment       => 'Postgres Repository',
          location      => "http://apt.postgresql.org/pub/repos/apt/", #$::apt-debian::params::psql_location,
          release       => "${::lsbdistcodename}-pgdg",
          repos         => "main",
        }
        apt::key{'7FCC7D46ACCC4CF8':
          ensure => present,
        }
      }
      if($vagrant_repo == true){
        apt::key {'vagrant_unoff_key':
          key        => 'CE3F3DE92099F7A4',
          key_server => 'pgp.mit.edu',
        }

        apt::source{'vagrant_deb_source':
          comment       => 'Unofficial Vagrant Repository',
          location      => "http://vagrant-deb.linestarve.com",
          release       => "any",
          repos         => "main",
          include_src   => false,
        }
        apt::pin{ 'vagrant': 
          origin   => 'vagrant-deb.linestarve.com',
          priority => '901',
        }
      }
      if($virtualbox_repo == true){
        apt::key{'54422A4B98AB5139':
          ensure     => present,
          key_source => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
        }
        apt::source{'oracle_virtualbox':
          comment   => 'Virtualbox Repository',
          location    => 'http://download.virtualbox.org/virtualbox/debian',
          release     => $::lsbdistcodename,
          repos       => 'contrib',
          include_src => false,          
          require   => Apt::Key['54422A4B98AB5139'],
        }

      }
    }
  }
}
