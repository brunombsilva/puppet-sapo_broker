class sapo_broker::php(
  $location = '/usr/share'
){

  package { ['libprotobuf-dev', 'cdbs', 'debhelper', 'autogen', 'dh-make-php', 'xsltproc']:
    require => Package['php5-dev', 'build-essential']
  }

  exec { "sapo_broker-php":
    command => 
          "cd $location/sapo-broker/clients/c-component/libsapo-broker2 &&
          sudo ./configure &&
          sudo make &&
          sudo make install &&
          cd $location/sapo-broker/clients/php-ext-component &&
          sudo phpize &&
          sudo ./configure &&
          sudo make &&
          sudo make install &&
          echo 'extension=sapobroker.so' > /etc/php5/conf.d/sapo_broker.ini &&
          sudo ldconfig",
    unless => 'php -m | grep sapobroker',
    provider => 'shell',
    require => [Git::Repo['sapo_broker'], Package['libprotobuf-dev', 'cdbs', 'debhelper', 'autogen', 'dh-make-php', 'xsltproc']]
  }
}
