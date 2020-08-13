#!/usr/bin/php
<?php
print("Current working directory=$_SERVER[PWD]\n");
$script_dir=substr($_SERVER['SCRIPT_FILENAME'],0,strrpos($_SERVER['SCRIPT_FILENAME'],"/"));
print("Script directory=$script_dir\n");
if(chdir($script_dir)) {
    print("Current working directory changed to=".getcwd()."\n");
} else {
    print("Failed to change current working directory\n");
}
require_once("PEAR.php");
//require_once("./goodyear_functions.php");
require_once("./network_includes.php");
require_once("./locking_functions.php");

$debug=FALSE;
$debug=TRUE;
$begin_end_flag=FALSE;
$begin_end_flag=TRUE;

if ($begin_end_flag) println(date("Y-m-d H:i:s")."*** Begin '".modulename()."' module");
println("Executing '/bin/env'");
system('/bin/env');

//**** Get exclusive lock or exit *****
$file_lock_handle=open_script_file_lock();

$auth=setup_auth();
$db_nidb=setup_mdb2('inventory');
$db_gaims=open_db('gaims');

$sql_nidb="SELECT userid,gaims_status_desc,smtp_address FROM users";
$nidb_users=getrowsfromdb($db_nidb,$sql_nidb);

foreach ($nidb_users as $nidb_user) {
   $nidb_userid=$nidb_user['userid'];
   if ($debug) {
      println("nidb_user=".print_r($nidb_user,TRUE));
   }
   $sql_gaims="
SELECT LOWER(user_id) AS userid, 
--   first_name AS firstname,
--   last_name AS lastname, 
   status_code_desc AS gaims_status_desc,
   smtp_email_address AS smtp_address 
FROM gaimsadmin.np_user_ids_view
WHERE user_id=UPPER('$nidb_userid')
";
   $gaims_user=getrowfromdb($db_gaims,$sql_gaims);
   if (empty($gaims_user)) {
      if ($debug) println("There is no GAIMS user for nidb_userid='$nidb_userid'");
      $in_gaims=FALSE;
   } else {
      if ($debug) println("gaims_user=".print_r($gaims_user,TRUE));
      $in_gaims=TRUE;
   }
   if ($in_gaims) {
      if ($nidb_user!=$gaims_user) { // THIS IS AN ARRAY comparision
	 $set_elements=array();
	 if ($nidb_user['gaims_status_desc']!=$gaims_user['gaims_status_desc']) {  // only change what we need to 
	    $set_elements[]="gaims_status_desc='$gaims_user[gaims_status_desc]'";
	    if ($gaims_user['gaims_status_desc']=='Inactive') {
	       $set_elements[]="groups=''";      // TAKE AWAY ALL their NIDB rights
	    }
	 }
	 if ($nidb_user['smtp_address']!=$gaims_user['smtp_address']) {
            $nidb_smtp_parts=explode('@',$nidb_user['smtp_address']);
            if ( isset($nidb_smtp_parts[1]) AND ($nidb_smtp_parts[1]!='goodyear.com')) {    // Therefore this is NOT a Goodyear address !
                  // DO NOTHING - keep this NON-Goodyear SMTP address
	    } else {
                  $set_elements[]="smtp_address='$gaims_user[smtp_address]'";
	    }
	 }
	 if (!empty($set_elements)) { // time to do an SQL UPDATE but only if there is at least one field to SET
	    $set_clause=" SET ".implode(', ',$set_elements);
	    $update_clause="UPDATE users";
            $where_clause=" WHERE userid='$nidb_userid'";
            $sql_nidb_update=$update_clause.$set_clause.$where_clause;
            if ($debug) println("sql_nidb_update=$sql_nidb_update");
            db_exec_check($db_nidb,$sql_nidb_update);
         }
      } // if $nidb_user!=$gaims_user
   } // if in_gaims
}

close_script_file_lock($file_lock_handle);

if ($begin_end_flag) println(date("Y-m-d H:i:s")."*** Exiting '".modulename()."' module");

?>
