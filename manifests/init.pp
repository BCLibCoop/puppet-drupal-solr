class drupal_solr (
  $user = 'tomcat6',
  $group = 'root',
  $manage_service = true,
  $solr_drupal_6_ref = '04117b5d52391eea48b5f8aa71d3b88ca788e9f1',
  $solr_drupal_7_ref = '072b12bd14e6029531609b8a81b3beab35f0b9e7',
  $solr_drupal_7_sapi_ref = '80e7f0e343f47364ee707dc10ef3b8994784bd7c'
) {

  include java
  include packagecloud

  packagecloud::repo { "zivtech/solr":
      type => 'deb',
  }

  file { '/usr/local/bin/create-solr-instance':
    source => "puppet:///modules/${module_name}/create-solr-instance",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/usr/local/bin/remove-solr-instance':
    source => "puppet:///modules/${module_name}/remove-solr-instance",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}



