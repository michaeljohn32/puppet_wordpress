class apt-debian($proxyhost = undef, $proxyport = undef, $release, $allow_unsigned_repos = false, $odoo = false, $mainserver = 'http://debian.cites.illinois.edu/pub/debian/', $psql_repo = false, $vagrant_repo = false,$virtualbox_repo = false){
  class { '::apt-debian::params': } ->
  class { '::apt-debian::config': 
    proxyhost            => $proxyhost,
    proxyport            => $proxyport,
    release              => $release,
    allow_unsigned_repos => $allow_unsigned_repos,
    odoo                 => $odoo,
    mainserver           => $mainserver,
    psql_repo            => $psql_repo,
    vagrant_repo         => $vagrant_repo,
    virtualbox_repo      => $virtualbox_repo,
  } ->
  Class['apt-debian']
}
