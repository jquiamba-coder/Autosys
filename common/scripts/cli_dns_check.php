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
require_once("./network_includes.php");
require_once("./locking_functions.php");
require_once "Net/Ping.php";

$begin_end_flag=TRUE;
$debug=FALSE;
$debug=TRUE;
$debug2=FALSE;
$debug2=TRUE;

if ($begin_end_flag) println(date("Y-m-d H:i:s")."*** Begin '".modulename()."' module");

//**** Get exclusive lock or exit *****
$file_lock_handle=open_script_file_lock();

// **** Set Up the Ping object ******************
$ping = Net_Ping::factory();
if (PEAR::isError($ping)) {
   echo $ping->getMessage();
   exit();
} else {
   $ping->setArgs(array('count' => 2));
}

$db=setup_mdb2('inventory');

$select_clause="SELECT CONCAT_WS('.',dns_name,dns_domain)";
$from_clause=" FROM devices";
$where_clause=" WHERE dns_name LIKE '%royalton%'";  //*** for testing
$where_clause=" WHERE dns_name LIKE '%ipsla%'";  //*** for testing
$where_clause=" WHERE dns_name LIKE '%tr-gebzebpmpls1-rtr%'";  //*** for testing
$where_clause="";
$order_clause="";
$limit_clause=" LIMIT 50";  //*** for testing
$limit_clause="";
$sql=$select_clause.$from_clause.$where_clause.$order_clause.$limit_clause;

$arr_dns_names=getcolfromdb($db,$sql);
foreach ($arr_dns_names as $hostname) {
    $hostpart=hostpart($hostname);
    $dns_info=@dns_get_record($hostname, DNS_ANY, $authns, $addtl);
    if ($debug2) {
        println("Hostname = $hostname");
        echo "<pre>Result = ".print_r($dns_info,TRUE)."</pre>";
        echo "<pre>Auth NS = ".print_r($authns,TRUE)."</pre>";
        echo "<pre>Additional = ".print_r($addtl,TRUE)."</pre>";
    }
    $valid_response=FALSE;
    foreach ($dns_info as $index => $dns_record) {
        if (isset($dns_record['ip'])) {
            $ip_address = $dns_record['ip'];
            $valid_response=TRUE;
            if ($debug) println("Found A record, IP=$ip_address");
        }
    }
    if (isset($authns[0]['target'])) { // there was a responding DNS !
        $responding_dns=$authns[0]['target'];
    } else {
        $responding_dns='';
    }
    if ($valid_response) {
	unset($set_item);  //*** If you don't do this you will end up with thousands of set items in your UPDATE SQL
        $set_item[]="dns_server='$responding_dns'";
        $set_item[]="dns_datetime=now()";
        $set_item[]="dns_response_ip4=".sprintf("%u",ip2long2($ip_address));

        //******** Now check the reverse (IP to Name) *******
	if ($hostname==gethostbyaddr($ip_address)) {
	    if ($debug) println("reverse dns is valid");
	    $set_item[]="dns_reverse_valid_datetime=now()";
	}

	$set_list=implode(', ',$set_item);
        $sql="UPDATE devices SET $set_list WHERE dns_name='$hostpart'";
        $result=db_exec_check($db,$sql);
        if ($debug2) println("sql=$sql");


        //******** Now ping the IP Address ***************
        $result=$ping->ping($ip_address);
        if ($debug2) {
            echo "<pre>"; var_dump($result); echo "</pre>";
        }
        $received=$result->getReceived();
        $result_text='transmitted='.$result->getTransmitted().
                       ', received='.$received.
                       ', loss='.$result->getLoss().
                       ', average='.(($received==0)?'N/A':$result->getAvg());
        if ($debug) println("result_text='$result_text'");
        if ($received!=0) {  //****** IF ping response
            $sql="UPDATE devices SET ping_response='$result_text',".
                                    "ping_datetime=now()".
                                    " WHERE dns_name='$hostpart'";
            $result=db_exec_check($db,$sql);
            if ($debug2) println("sql=$sql");
        } //** end IF ping response
    } else { //** ELSE there was no valid DNS response
        $responding_dns='';
        $ip_address='';
    }
    if ($debug) {
        println("hostname='$hostname'");
        println("hostpart=$hostpart, responding DNS=$responding_dns, IP Address=$ip_address");
        println();
    }
}

close_script_file_lock($file_lock_handle);
if ($begin_end_flag) println(date("Y-m-d H:i:s")."*** Exiting '".modulename()."' module");

?> 
