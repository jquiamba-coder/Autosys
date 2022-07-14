<?php

//test_get_ldap_user();

function test_get_ldap_user() {
$ldap=get_ldap_user('NEIF124');
print("ldap userid='$ldap[userid]'\n");
print("ldap email='$ldap[mail]'\n");
print("ldap region='$ldap[region]'\n");
print("ldap domain='$ldap[domain]'\n");
print("ldap firstname='$ldap[firstname]'\n");
print("ldap lastname='$ldap[lastname]'\n");
print("ldap dn='$ldap[dn]'\n");

print("\n");

$ldap=get_ldap_user('A404829');
print("ldap userid='$ldap[userid]'\n");
print("ldap email='$ldap[mail]'\n");
print("ldap region='$ldap[region]'\n");
print("ldap domain='$ldap[domain]'\n");
print("ldap firstname='$ldap[firstname]'\n");
print("ldap lastname='$ldap[lastname]'\n");
print("ldap dn='$ldap[dn]'\n");
}

function get_ldap_user($userid=''){
  $debug=TRUE;
  $debug=FALSE;
  $ldap['userid']=$userid;
  $ldap['mail']='';
  $ldap['region']='';
  $ldap['domain']='';
  $ldap['firstname']='';
  $ldap['lastname']='';

  $AuthLDAPBindDN='NA\LDNIDB1';
  $AuthLDAPBindPassword='9Yf1Mu2Nv1Px1Mu';

  $ldap_servers=array("akrdcna1.na.ad.goodyear.com", "akrdcna2.na.ad.goodyear.com");
  foreach ($ldap_servers as $ldap_server) {
 	$ldap_res=ldap_connect($ldap_server,3268);  // You must use this port to see other BaseDN 
  	break;
  }
    
  if (!$ldap_res) {
    die("failed to connect: LDAP Servers=".print_r($ldap_servers,TRUE));
  }
  
  ldap_set_option($ldap_res, LDAP_OPT_REFERRALS, 0);
  ldap_set_option($ldap_res, LDAP_OPT_PROTOCOL_VERSION, 3);

  $ldap_bind = ldap_bind($ldap_res,$AuthLDAPBindDN, $AuthLDAPBindPassword)
    or die("failed to bind '$AuthLDAPBindDN' to '$ldap_addr'");

  $filter="(&(objectClass=user)(samAccountName=$userid))";
  $justthese = array('mail','givenname','sn','dn','co');

  $basedn= "DC=ad,DC=goodyear,DC=com";

  $search_result=ldap_search($ldap_res, $basedn, $filter, $justthese)
    or die("failed to search with:".
    "\nbasedn=".print_r($basedns,TRUE).
    "\nfilter=".print_r($filter,TRUE).
    "\njustthese=".print_r($justthese,TRUE)
    );

  $info=ldap_get_entries($ldap_res,$search_result);
  if ($debug) print_r($info);
  $ldap['mail']=$info[0]['mail'][0];
  $ldap['firstname']=$info[0]['givenname'][0];
  $ldap['lastname']=$info[0]['sn'][0];
  $ldap['region']=$info[0]['co'][0];
  $ldap['dn']=$info[0]['dn'];
  $pos_domain=stripos($ldap['dn'],',DC=ad,DC=goodyear,DC=com')-2;
  $ldap['domain']=substr($ldap['dn'],$pos_domain,2);
  return($ldap);
}
?>
