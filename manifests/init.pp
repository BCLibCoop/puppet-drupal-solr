class drupal_solr (
  $tomcatuser = 'tomcat6',
  $webadmingroup = 'root',
  $manage_service = true,
  $solr_drupal_7_sapi_ref = '80e7f0e343f47364ee707dc10ef3b8994784bd7c'
) {

  package {
    [
      'tomcat6',
      'tomcat6-admin',
    ]:
      ensure => installed
}

  if ($manage_service) {
    service { 'tomcat6':
      require => Package['tomcat6'],
      ensure => running,
      subscribe => [
        File['/etc/tomcat6/Catalina/localhost'],
        File['/var/lib/tomcat6/webapps'],
      ],
    }
    -> File['/usr/local/bin/create-solr-instance']
    -> File['/usr/local/bin/remove-solr-instance']
  }

  logrotate::rule { 'tomcat':
    path         => '/var/log/tomcat/catalina.out',
    copytruncate => true,
    rotate_every => 'day',
    rotate       => 5,
    compress     => true,
    missingok    => true,
    size         => '10M'
  }

  file { '/opt/solr':
    require => Package['tomcat6'],
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0775',
  }

  vcsrepo { '/opt/solr/sapi-solrbase-7':
    source   => 'https://github.com/zivtech/Solr-base.git',
    ensure   => 'present',
    provider => 'git',
    revision => $solr_drupal_7_sapi_ref,
    owner    => $user,
    group    => $group,
    require  => [
      File['/opt/solr'],
      Package['tomcat6']
    ],
  }

  file { '/usr/local/bin/create-solr-instance':
    source => "puppet:///modules/${module_name}/create-solr-instance",
    owner => 'root',
    group => 'root',
    mode => 755,
  }

  file { '/usr/local/bin/remove-solr-instance':
    source => "puppet:///modules/${module_name}/remove-solr-instance",
    owner => 'root',
    group => 'root',
    mode => 755,
  }

  file { '/etc/tomcat6/Catalina/localhost':
    ensure  => 'directory',
    owner   => 'root',
    group   => $webadmingroup,
    require => [
      Package['tomcat6'],
    ],
  }

  file { '/var/lib/tomcat6/webapps':
    ensure => 'directory',
    owner  => $tomcatuser,
    group  => $webadmingroup,
  }
}
