<?php

//test_email();
function test_email() {

   $to_recipients = array (
      'patrick_volz@goodyear.com',
   );
   $from='Network Inventory<NO_EMAIL@gsno.akr.goodyear.com>';  // CHECK CAREFULLY the <>, @, and syntax here. mistakes, prevent e-mail sending.
   send_mail('test subject','hello world',$from,$to_recipients);

   $from='Network Inventory<NO_EMAIL@gsno.akr.goodyear.com>';
   $to_recipients=array(
      'Patrick Volz<patrick_volz@goodyear.com>',
      'Craig Makrucki<craig_makrucki@goodyear.com>',
      'Jason Rodd<jason.rodd@goodyear.com>',
      'Andrew Buckroyd<andrew.buckroyd@goodyear.com>',
   );
   $cc_recipients=array(
      'Patrick Volz<patrickvolz@hotmail.com>',
   );
   $device_id='testtesttest-rtr';
   $datetime_str='2015-01-01 00:00';
$mailsubject="Device '$device_id' successfully added to NIDB at $datetime_str";
$a_href_value="'http://gsno.goodyear.com/device?dns_name=$device_id'";
$html=<<<END
<html>
<body>
<span style='color:green;'>$mailsubject</span><br \>
Direct link to device details: <a href=$a_href_value>$device_id</a><br \>
<br />
</span>
</body>
</html>
END;
   send_mail($mailsubject,$html,$from,$to_recipients,$cc_recipients);

}

function send_mail($subject='',$html='',$from='',$to_recipients,$cc_recipients=array(),$attachments=array()) {
   $debug=FALSE;
   $debug=TRUE;
   include_once('Mail.php');
   include_once('Mail/mime.php');
   ini_set('SMTP','gyrelay.akr.goodyear.com');

   // Add file attachments if we have them
   $message= new Mail_mime();
   $message->setHTMLBody($html);
   foreach ($attachments as $attachment) {
      $message->addAttachment($attachment);
   }

   $extraheaders=array(
	"From"   =>$from,
	"Subject"=>$subject,
	"Cc"=>$cc_recipients,
	);
   if ($debug) {
      print('to_recipients='.print_r($to_recipients,TRUE)."\n");
      print('extraheaders='.print_r($extraheaders,TRUE)."\n");
      print('html='.print_r($html,TRUE)."\n");
   }
   $body = $message->get(); // This MUST be called before headers() method
   $headers=$message->headers($extraheaders);

   if ($debug) print('headers='.print_r($headers,TRUE)."\n");

   $mail = Mail::factory('mail');
   $mail->send($to_recipients,$headers,$body);
}

function compress($filename,$zip_filename='') {
   $debug=TRUE;
   $debug=FALSE;

   if ($debug) {
      println("filename='$filename', basename(filename)='".basename($filename)."', supplied zip_filename='$zip_filename'");
   }

   if ($zip_filename=='') {
      if ($debug) println("zip_filename NOT supplied");
      $pos_dot=strrpos($filename,'.');
      if ($pos_dot===FALSE) {
         $zip_filename=$filename.'.zip';
      } else {
         $zip_filename=substr($filename,0,$pos_dot).'.zip';
      }
   }
   if ($debug) println("zip_filename='$zip_filename'");

   $zip = new ZipArchive;
   $flags=ZIPARCHIVE::CREATE|ZIPARCHIVE::OVERWRITE;
   $result=$zip->open($zip_filename,$flags);
   if ($result===TRUE) {
      $zip->addFile($filename,basename($filename));
      $zip->close();
      if ($debug) println("compression worked for filename='$filename' into archive '$zip_filename'");
      return($zip_filename);
   } else {
      if ($debug) println("compression failed for filename='$filename' into archive '$zip_filename'");
      return(FALSE);
   } 
}

?>
