class sapo_broker::agent(
  $location = '/workspace'
){

  package { ['libboost-dev', 'libboost-test-dev', 'libboost-program-options-dev', 'libevent-dev', 'flex', 'bison', 'pkg-config', 'g++', 'libssl-dev', 'automake', 'libtool', 'protobuf-compiler' ]:
  }

  exec { "thrift":
    command => 
      "cd /$location/thrift &&
       ./bootstrap.sh &&
       ./configure &&
       make &&
       make install",
    creates => '/usr/local/bin/thrift',
    provider => 'shell',
    timeout => 0,
    require => [Git::Repo['thrift'], Package['libboost-dev', 'libboost-test-dev', 'libboost-program-options-dev', 'libevent-dev', 'flex', 'bison', 'pkg-config', 'g++', 'libssl-dev', 'automake', 'libtool' ]]
  }

  exec { "sapo_broker-agent":
    command => 
    "rm $location/sapo-broker/common-libs/libthrift*.jar &&
    cp $location/thrift/lib/java/build/libthrift*.jar $location/sapo-broker/common-libs/ &&
    cd $location/sapo-broker/agent &&
    ant build",
    provider => 'shell',
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/" ],
    unless => "find $location/sapo-broker/agent/dist/sapo-broker-agent*",
    require => [Git::Repo['sapo_broker'], Exec['thrift'], Package['protobuf-compiler']]
  }

  git::repo { 'thrift':
    path => "$location/thrift",
    source => 'http://git-wip-us.apache.org/repos/asf/thrift.git'
  }
}
