class sapo_broker::php(
  $location = '/usr/share'
){

  package { ['libprotobuf-dev', 'cdbs', 'debhelper', 'autogen', 'dh-make-php', 'xsltproc']:
    require => Package['php5-dev', 'build-essential']
  }

  exec { "sapo_broker-php":
    command => 
          "cd $location/sapo-broker/clients/c-component/libsapo-broker2 &&
          autoreconf &&
          automake &&
          ./make_deb.sh &&
          sudo dpkg -i ../libsapo-broker2_2.1.0_i386.deb &&
          sudo dpkg -i ../libsapo-broker2-dev_2.1.0_i386.deb &&
          cd $location/sapo-broker/clients/php-ext-component &&
          sed -i 's/--only/--phpversion/g' build.sh &&
          ./build.sh &&
          sudo dpkg -i php5-sapobroker_0.3-1_i386.deb",
    unless => 'php -m | grep -c sapobroker',
    provider => 'shell',
    require => [Git::Repo['sapo_broker'], Package['libprotobuf-dev', 'cdbs', 'debhelper', 'autogen', 'dh-make-php', 'xsltproc']]
  }
}
