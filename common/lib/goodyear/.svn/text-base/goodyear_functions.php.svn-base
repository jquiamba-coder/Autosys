<?php
// THESE FUNCTIONS BELONG IN A COMMON LIBRARY TO BE SHARED BY ALL

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
   $extraheaders[]="Content-Type: text/html; charset=UTF-8";
   $body = $message->get(); // This MUST be called before headers() method
   $headers=$message->headers($extraheaders);

   if ($debug) print_r($headers);
   if ($debug) print "Sending email to:" . $to_recipients;

   $mail = Mail::factory('mail');
   $mail->send($to_recipients,$headers,$body);
}

function compress($filename,$zip_filename='') {
   $debug=TRUE;
   $debug=FALSE;

  if ($debug){

    println(
      "filename='$filename', basename(filename)='"
      . basename($filename)
      . "', supplied zip_filename='$zip_filename'");

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


function sortByLen($a, $b) {
  if (strlen($a) == strlen($b)) {
    return 0;
  } else {
    return( (strlen($a)>strlen($b))?-1:1 );
  }
}


if (!function_exists('println')) {
  function println($in_string='') {
    static $linefeed;
    //From maunual:
    // A static variable exists only in a local function scope, but it does not lose its value when program execution leaves this scope.
    if (!isset($linefeed)) {
      if (in_array(php_sapi_name(), array('cli', 'cgi')) && empty($_SERVER['REMOTE_ADDR'])) {
        $linefeed = "\n";
      } else {
        $linefeed = "<br />\n";
      }
    }
    echo $in_string.$linefeed;
  }
}
function datetimestring($tz='UTC') {
    // ****** create the DateTimeZone objects ******
    if (($tz=='') or ($tz==null)) {
        $tz='UTC';
    }
    $tz_utc =timezone_open($tz_utc_str ='UTC');    // Create new DateTimeZone object
    if ($tz_utc===FALSE) {                         // check for failure
        die("timezone_open failed, tz_utc_str=$tz_utc_str");
    }
    $date=date_create('',$tz_utc);                 // Create new UTC DateTime object
    if ($date===FALSE) {                           // Check for failure
        die("date_create failed for tz_utc");
    }
    if ($tz!='UTC') {
        $tz_site=timezone_open($tz);               // Create new DateTimeZone object
        if ($tz_site===FALSE) {                    // check for failure
            die("timezone_open failed for tz_site");
        }
        //******* site the timezone for the site *************
        $rc=date_timezone_set($date,$tz_site);        // Convert to site TimeZone
        if ($rc===FALSE) {
            die("date_timezone_set failed for tz_site");
        }
    }
    return($date_str=$date->format("Y-m-d H:i:s, l")." ($tz)");
}

function file_write($filename,$contents) {
    $handle=fopen($filename,'wb');   // 'wb' means rewrite the file in binary mode
    if ($handle===FALSE) {
       die("Can not open filename='$filename'");
    }
    fwrite($handle,$contents);
    fclose($handle);
}



?>