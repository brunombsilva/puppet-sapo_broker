class sapo_broker (
  $agent,
  $php,
  $location = '/usr/share'
) {
  if $agent {
    class { 'sapo_broker::agent':
      location => $location
    }
  }

  if $php {
    class { 'sapo_broker::php':
      location => $location
    }
  }

  git::repo { 'sapo_broker':
    path => "$location/sapo-broker",
    source => 'https://github.com/sapo/sapo-broker.git'
  }

}
