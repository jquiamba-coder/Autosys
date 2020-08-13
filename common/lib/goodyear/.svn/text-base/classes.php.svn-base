<?php

class HTMLTable {
//**** need to write this, because it will be more efficient than PEAR HTML_Table
    var $obj_table;

    function __construct() {
    $doctype = DOMImplementation::createDocumentType("html",
               "-//W3C//DTD HTML 4.01//EN",
               "http://www.w3.org/TR/html4/strict.dtd");
    $this->obj_table=DOMImplementation::createDocument(null, 'html', $doctype); 
    $this->obj_table=DOMDocument::loadXML('<table border="3" cellspacing="1" bordercolor="#C0C0C0" width="100%"><tr><th>TEST</th><th>JUNK</th></tr></table>');

    //************ Output the HTML / XML of the Table object **********************
    $this->obj_table->formatOutput = TRUE; //** we want a nice output
    echo "<b>XML Request:</b><pre>".  htmlentities($this->obj_table->saveXML())."</pre><br>";
    echo $this->obj_table->saveXML();
    }

    function setHeaderContents($header_content) {
        $obj_headerlist=$this->obj_table->getElementsByTagName('th');
        for ($i = 0; $i < $obj_headerlist->length; $i++) {
            //echo "i=$i, nodeTag=$obj_headerlist->item($i)->nodeTag, nodeValue=$obj_headerlist->item($i)->nodeValue<br />\n";
            echo "i=$i, nodeValue=".$obj_headerlist->item($i)->nodeValue.", tagName=".$obj_headerlist->item($i)->tagName."<br />\n";
        }
    $obj_th=$this->obj_table->createElement('th',htmlentities($header_content));
    $obj_headerlist->item(0)->appendChild($obj_th);

    $this->obj_table->formatOutput = TRUE; //** we want a nice output
    echo "<b>XML Request:</b><pre>".  htmlentities($this->obj_table->saveXML())."</pre><br>";
    echo $this->obj_table->saveXML();
    }

}

class RecordList {
    var $db;
    var $sqlquery;
    var $sqlresult;
    var $htmltable;
    var $gets;       //********* 3 types of gets: [array] or [setstrings] or [string]
    var $headings;   //********* 4 types of headings: [text][html][sqlin][sqlout]
    var $caption;
    var $totalrecs_nolimit;
    var $offsetrecord=0;    
    var $recsperpage=500;    
    var $lastdisplayrecord;    
    var $maxpage;    
    var $thispage;    
    var $module;    
    var $order; //***** [text][sqlout][direction]    

    function __construct() {
        $index=0; 
        foreach ($_GET as $key => $value) {
            $this->gets['array'][$key]=$value;
            if (is_array($value)) {
                foreach ($value as $key1 => $value1) {
                    $this->gets['setstrings'][$index++]=$key.'['.$key1.']='.$value1;
                }
            } else {
                $this->gets['setstrings'][$index++]=$key.'='.$value;
            }
        }
        if (isset($this->gets['array'])) {
            $this->gets['string']='?'.implode('&',$this->gets['setstrings']);   //******** remake the gets['setstrings']
        }
        // $this->gets['string']=$_SERVER['QUERY_STRING'];  //****** prefer to make our own, but not checking for consistency yet

    }

    function htmlTable() {
	global $auth2;
        $debug=TRUE;
        $debug=FALSE;
        $attributes=array("class"=>"visible stripeMe","width"=>"100%");
        $this->htmltable = new HTML_Table($attributes);
        $row=0; $col=0;
        //echo "<pre>"; print_r($this); echo "</pre>";
        if (isset($this->headings['html'])) {
            foreach($this->headings['html'] as $key => $value ) {
                if (substr($this->headings['sqlout'][$key],-7)!='_noshow') {
                    $this->htmltable->setHeaderContents($row,$col,$this->headings['html'][$key]);
                    //$this->htmltable->setHeaderContents($this->headings['html'][$key]);
                    $col++;
                }
            }
        } else {
            foreach($this->headings['text'] as $key => $value) {
                if (substr($this->headings['sqlout'][$key],-7)!='_noshow') {
                    $this->htmltable->setHeaderContents($row,$col,$this->headings['html'][$key]);
                    //$this->htmltable->setHeaderContents($this->headings['html'][$key]);
                    $col++;
                }
            }
        }
        $this->htmltable->setRowAttributes($row,array('class'=>'menu'),$inTR=TRUE);

        //***************** Do the remainder paging record number calculations *****************
        if ($this->totalrecs_nolimit==0) {
            $this->thispage=0;
        } else {
            $this->thispage=($this->offsetrecord/$this->recsperpage)+1;
        }
        $this->maxpage=ceil($this->totalrecs_nolimit/$this->recsperpage);
        if ($this->thispage!=$this->maxpage) {  //*************not last page ************************
            $this->lastdisplayrecord=$this->offsetrecord+$this->recsperpage;
        } else { //****************** last page **************
            $this->lastdisplayrecord=$this->totalrecs_nolimit;
        }
        if ($this->lastdisplayrecord>$this->totalrecs_nolimit) {
            $this->lastdisplayrecord=$this->totalrecs_nolimit;
        }
        
        //**************** Make up the appropriate URLs for first,prev,next,last hyperlinks*********
        $first="[first]";$prev="[prev]";$next="[next]";$last="[last]";
        $temp_array=$this->gets['array'];
        if ($this->thispage>1) { //***** not the first page ******************
            $temp_array['offsetrecord']=0;
            $first=thissite_ahref($this->module.buildurlgetstring($temp_array),$first);
            $temp_array['offsetrecord']=$this->offsetrecord-$this->recsperpage;
            $prev=thissite_ahref($this->module.buildurlgetstring($temp_array),$prev);
        }
        if (ceil($this->thispage)!=$this->maxpage) {
            $temp_array['offsetrecord']=$this->offsetrecord+$this->recsperpage;
            $next=thissite_ahref($this->module.buildurlgetstring($temp_array),$next);
            $temp_array['offsetrecord']=($this->maxpage-1)*$this->recsperpage;
            $last=thissite_ahref($this->module.buildurlgetstring($temp_array),$last);
        }
        
        if ( ($this->totalrecs_nolimit==0)OR!($this->offsetrecord<$this->totalrecs_nolimit) ) {
            $x_to_y_string="";
        } else {
            $x_to_y_string="<b>".sprintf("%d",$this->offsetrecord+1)."</b> to <b>$this->lastdisplayrecord</b> of ";
        }
        $this->caption['html']='<span style="color:blue;">'.
                               //"thispage=$this->thispage, maxpage=$this->maxpage, ".
                               $x_to_y_string.
                               "<b>$this->totalrecs_nolimit</b> ".
                               $this->caption['text'].
                               '</span>';
        //$captiontable = new HTML_Table(array("border"=>"0","width"=>"100%") );
        $captiontable = new HTML_Table(array("width"=>"100%") );
        $captiontable->setCellContents(0,1,$this->caption['html']);
        $captiontable->setCellAttributes(0,1,array("align"=>"center"));
        $captiontable->setCellContents(0,0,$first.$prev);
        $captiontable->setCellAttributes(0,0,array("align"=>"left"));
        $captiontable->setCellContents(0,2,$next.$last);
        $captiontable->setCellAttributes(0,2,array("align"=>"right"));
        $captiontable->display();
        //$this->htmltable->setCaption($this->caption['html'],array('align'=>'top','halign'=>'left'));
	$row=1;
	foreach ($this->sqlresult as $recordnum => $record) {
            $attributes = array("align"=>"left");
	    $col=0;
	    if ($debug) println("-------------------processing recordnum $recordnum -------------------------------------------------------------");
	    foreach ($record as $fieldname => $fieldvalue) {
                if ($debug) print("$fieldname='$fieldvalue'");
                if (substr($fieldname,-7)=='_noshow') {
                    if ($debug) println(" --- skip this field");
                    // **** do nothing ****
                } elseif ( (isset($record['ip_type']))AND($record['ip_type']=='network')AND(($fieldname=='dns_name')OR($fieldname=='interface_name')OR($fieldname=='interfacetype')) ) {
                    if ($debug) println(" --- skip this field");
                    // **** do nothing ****
                } elseif ( (isset($record['ip_type']))AND($fieldname=='ipnetwork_comment')AND($record['ip_type']=='interface') ) { 
                    if ($debug) println(" --- skip this field");
                    // **** do nothing ****
                } elseif ($fieldvalue=='') { 
                    if ($debug) println(" --- set table cell contents to 'nbsp'");
                    $this->htmltable->setCellContents($row,$col++,'&nbsp;'); //**** fill the html table cell with the html blank char
                } else {
		if ($debug) println();
		switch ($fieldname) {
		
		case 'agreement_id':
		    $cellhtml=thissite_popup_ahref('agreement?agreement_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'circuit_id':
                    $cellhtml=thissite_popup_ahref('circuit?circuit_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'contact_name':
		case 'contact_name_1_ibh':
		case 'contact_name_2_ibh':
		case 'contact_name_3_ibh':
		case 'contact_name_4_ibh':
		case 'contact_name_5_ibh':
		case 'contact_name_1_obh':
		case 'contact_name_2_obh':
		case 'contact_name_3_obh':
		case 'contact_name_4_obh':
		case 'contact_name_5_obh':
		case 'contact_name_ops_service':
		case 'contact_name_ops_client':
		case 'contact_name_admin_service':
		case 'contact_name_admin_client':
		    $pieces=explode('_',$fieldname);
		    if (!isset($pieces[2])) {
		       $stringy='id';
		    } else {
		       $stringy=$pieces[2].'_'.$pieces[3];
		    }
		    //println("stringy='$stringy'");
		    $cellhtml=thissite_popup_ahref('contact?contact_id='.$record['contact_'.$stringy.'_noshow'],$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'contract_id':
		    $cellhtml=thissite_popup_ahref('contract?contract_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'country_count':
		    $cellhtml=thissite_ahref('countrylist?search_string=&region_id='.urlencode($record['region_id']),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'count_applications':
                    $cellhtml=thissite_ahref('applicationlist?search_string=&device_id='.urlencode($record['device_id']),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'count_servers':
                    $cellhtml=thissite_ahref('serverlist?search_string=&itservice_name='.urlencode($record['itservice_name']),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

                case 'device':
                    $cellhtml=thissite_popup_ahref('statseekerdevice?device='.urlencode($record['device']),$record['device']);       
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

                //case 'device_id':
                //    $cellhtml=thissite_popup_ahref('server?device_id='.urlencode($record['device_id']),$record['device_id']);       
	        //    $this->htmltable->setCellContents($row,$col++,$cellhtml);
                //break;

                case 'data':
                    $cellhtml=thissite_popup_ahref('o365data?o365type='.$record['o365type'].'&data='.urlencode($record['data']),$record['data']);       
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

                case 'directory':
                    $cellhtml=thissite_popup_ahref('directory?directory='.urlencode($record['directory']),$record['directory']);       
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

		case 'dns_name':
		    if ( (!(isset($record['iptype']))) OR
                         ((isset($record['iptype']))AND($record['iptype']!='network')) ) {
                        $cellhtml=thissite_popup_ahref('device?dns_name='.urlencode($fieldvalue),$fieldvalue);
	                $this->htmltable->setCellContents($row,$col++,$cellhtml);
                    }
		break;

                case 'file_count':
                    if (isset($record['directory'])) {
                        $cellhtml=thissite_ahref('filelist?search_string=&directory='.urlencode($record['directory']),$fieldvalue);
                    } else {
                        $cellhtml=$fieldvalue;
                    }
                    $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

		case 'filename':
                    if (isset($record['authorized'])) {
                        $file_auth=$record['authorized'];
                    } else {
                        $file_auth=getonefromdb($this->db,"SELECT authorized FROM files WHERE filename=".$this->db->quote($fieldvalue,'text'));
                    }
                    if (isset($record['filenet_id'])) {
                        $filenet_id=$record['filenet_id'];
                    } elseif (isset($record['filenet_id_noshow'])) {
                        $filenet_id=$record['filenet_id_noshow'];
	            } else {	
                        $filenet_id=getonefromdb($this->db,"SELECT filenet_id FROM files WHERE filename='$fieldvalue'");
                    }
		    //$cellhtml=thissite_ahref('filedownload.php?filename='.urlencode($fieldvalue),$fieldvalue).
		    $display_filename=htmlentities($fieldvalue);
		    if ($file_auth=='public') {
                        $cellhtml="<a href=javascript:popUpWindowRecord('http://fnp8appengine.akr.goodyear.com:9085/Workplace/GDYRCustom.jsp".
                              "?ObjectStoreName=GYOS1P&VersionID=$filenet_id')>$display_filename</a>";
		    } else {
                        $cellhtml="<a href=javascript:popUpWindowRecord('https://ahqgdsf.akr.goodyear.com/Workplace/getContent".
                              "?id=release&vsId=$filenet_id&objectStoreName=GYOS1P&objectType=document')>$display_filename</a>";
		    }
                    $cellhtml.='----'.thissite_popup_ahref('file?filename='.urlencode($fieldvalue),'[detail]');
                    $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'filenet_id':
		    $is_test_code=(strpos($_SERVER['SCRIPT_FILENAME'],'/test/')!==FALSE);
		    $is_test_code=FALSE;
		    if ($record['authorized']=='public') {
		       $color='green';
		       if (!$is_test_code) {
		           $cellhtml="<a href=javascript:popUpWindowRecord('http://fnp8appengine.akr.goodyear.com:9085/Workplace/GDYRCustom.jsp".
		                    "?ObjectStoreName=GYOS1P&VersionID=$record[filenet_id]')>".
	                            "<span style='color:$color;'>[Filenet]</span>".
			      '</a>';
		       } else {
		           $cellhtml='<a href=javascript:popUpWindowRecord("http://akrlx036.akr.goodyear.com:9085/Workplace/GDYRCustom.jsp'.
		                    '?ObjectStoreName=FNP8OS1&VersionID='. $record['filenet_id']. '")>'.
	                            "<span style='color:$color;'>[Filenet]</span>".
			      '</a>';
		       }
		    } else {
		       $color='darkred';
		       if (!$is_test_code) {
		           $cellhtml='<a href=javascript:popUpWindowRecord("https://ahqgdsf.akr.goodyear.com/Workplace/getContent'.
		                    '?id=release&vsId='. $record['filenet_id']. '&objectStoreName=GYOS1P&objectType=document")>'.
	                            "<span style='color:$color;'>[Filenet]</span>".
	     	              '</a>';
		       } else {
		           $cellhtml='<a href=javascript:popUpWindowRecord("http://akrlx036.akr.goodyear.com:9085/Workplace/getContent'.
		                    '?id=release&vsId='. $record['filenet_id']. '&objectStoreName=FNP8OS1&objectType=document")>'.
	                            "<span style='color:$color;'>[Filenet]</span>".
	     	              '</a>';
		       }
		    }
		    //NOT secure
		    //http://fnp8appengine.akr.goodyear.com:9085/Workplace/GDYRCustom.jsp?ObjectStoreName=GYOS1P&VersionID=%7B'.$filenet_id.'%7D';
		    //secure
		    //https://ahqgdsf.akr.goodyear.com/Workplace/getContent?id=release&vsId=%7B5227CBFA-9822-4530-A167-BBC3FE8699BD%7D&objectStoreName=GYOS1P&objectType=document
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;
		
                case 'filesize':
                    $this->htmltable->setCellContents($row,$col++,byte_format($fieldvalue));
                break;
		
		case 'helptopic':
		    $cellhtml=thissite_popup_ahref('help?helptopic='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'ip_network':
		    if ($record['iptype_noshow']=='network') {
                        $cellhtml=thissite_popup_ahref("ipnetwork?ip_net_start=$fieldvalue&ip_netmask=$record[ip_netmask_dotted]",$fieldvalue.'/'.$record['ip_netmask_slash']);
			$cellhtml=str_repeat('&nbsp;&nbsp;',$record['level_noshow']).$cellhtml;  // poor man's hierarchical display
	                $this->htmltable->setCellContents($row,$col++,$cellhtml);
                    }
		break;

                case 'isindb':
                    $cellhtml=$record['isindb'];
                    if ($record['isindb']=='OK') {
                        $cellhtml='<span class="ok">'.$cellhtml.'</span> ('.
                                   thissite_popup_ahref('device?dns_name='.urlencode($record['device']),$record['device']).
                                   ')';
                    } else {
                        $cellhtml='<span class="error">'.$cellhtml.'</span>';
                    }
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

                case 'isinss':
                    $cellhtml=$record['isinss'];
                    if ($record['isinss']=='OK') {
                        $cellhtml='<span class="ok">'.$cellhtml.'</span> ('.
                                   thissite_popup_ahref('statseekerdevice?device='.urlencode($record['dns_name']),$record['dns_name']).
                                   ')';
                    } else {
                        $cellhtml='<span class="error">'.$cellhtml.'</span>';
                    }
                    $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

                case 'itservice_name':
                    if ((!isset($record['itservice_type'])) or ($record['itservice_type']=='application')) {
                        $cellhtml=thissite_popup_ahref('itservice?itservice_name='.urlencode($record['itservice_name']),$record['itservice_name']);       
                    } elseif ($record['itservice_type']=='network') {
                        $cellhtml=thissite_popup_ahref('site?site_id='.urlencode($record['itservice_name']),$record['itservice_name']);
                    }
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

		case 'rnx':
		    $cellhtml=thissite_popup_ahref('voiceroute?rnx='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

                case 'sent_datetime':
                    $cellhtml=thissite_popup_ahref('notification_update?sent_datetime='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

		case 'site_count':
                    if (isset($record['country_id'])) {
                        $cellhtml=thissite_ahref('sitelist?search_string=&country_id='.urlencode($record['country_id']),$fieldvalue);
                    } else {
                        $cellhtml=$fieldvalue;
                    }
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'site_id':
                    $cellhtml=thissite_popup_ahref('site?site_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

                case 'street_address2':
                     $cellhtml=utf8_encode($fieldvalue);
                     $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;


		case 'task_id':
		    $cellhtml=thissite_popup_ahref('task?task_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'org_id':
                    $cellhtml=thissite_popup_ahref('org?org_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

                case 'parent_circuit_id':
                    $cellhtml=thissite_popup_ahref('circuit?circuit_id='.urlencode($fieldvalue),$fieldvalue);
                    $this->htmltable->setCellContents($row,$col++,$cellhtml);
                break;

		case 'parent_org_id':
		    $cellhtml=thissite_popup_ahref('org?org_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

		case 'record_id':
		    $cellhtml=thissite_popup_ahref('logdetail?table_name='.urlencode($record['table_name']).'&record_id='.urlencode($fieldvalue),$fieldvalue);
	            $this->htmltable->setCellContents($row,$col++,$cellhtml);
		break;

                case 'userid':
		    if ($auth2->is_auth('admin')) {
		        $cellhtml=thissite_popup_ahref('user?userid='.urlencode($fieldvalue),$fieldvalue);
	                $this->htmltable->setCellContents($row,$col++,$cellhtml);
		    } else {
		        $this->htmltable->setCellContents($row,$col++,$fieldvalue);
	            }
		break;

		default:
	            $this->htmltable->setCellContents($row,$col++,$fieldvalue);
	        break;

                } // switch
	        } // else
	    } // foreach $record
            //******* this does the alternating colors ***************
            //*****  has been disabled, causes too much delay in xhtml redndering time
            //$this->htmltable->altRowAttributes($start=1, array("class"=>"odd"), array("class"=>"even"), $inTR=TRUE);
            if (($row % 2) == 0) {   //*** if this is an even row
                $rowAttributes=array('class'=>'even');
            } else {
                $rowAttributes=array('class'=>'odd');
            }
	    if ( (isset($record['ip_type'])) AND ($record['ip_type']=='network') ) {
                $rowAttributes=array('class'=>'separator');
            } else {
                if (isset($record['color_sample'])) {
                    $style_array=array('style'=>'background-color:#'.$record['color_sample']);
                    $this->htmltable->setCellAttributes($row,$col=1,$attributes + $style_array);
                    $this->htmltable->setCellContents($row,$col=1,'&nbsp;');
                }
            }
            $this->htmltable->setRowAttributes($row,$rowAttributes,$inTR=TRUE);
	    $row++;
	    //$this->htmltable->addRow($record,$attributes);
	} // foreach this->sqlresult
        //echo "<span style='background-color:#00FF00;'>";
        $this->htmltable->display();
        //echo "</span>";
        $captiontable->display();
    }
    
    function sqlQuery($sqlquery) {
        //**************************** modify the SQL to insert the SQL_CALC_FOUND_ROWS option***************
        $pos=stripos($sqlquery,$selectstr='SELECT ');
        if ( ($pos===FALSE)OR($pos > 5) ) {
            die("No '$selectstr' string found in first 5 characters of SQL='$sqlquery'");
        } else {
	    $sqlquery=substr_replace($sqlquery,$replaceselectstr='SELECT SQL_CALC_FOUND_ROWS ',$pos,strlen($selectstr));
        }

        //*********************** Do the calculations needed for SQL LIMIT calculations ***********************
        if (isset($_GET['offsetrecord'])) {
            $this->offsetrecord=$_GET['offsetrecord'];
            if ($this->offsetrecord<0) $this->offsetrecord=0;
        }
        $limit_clause=" LIMIT $this->offsetrecord,$this->recsperpage";
        //*********************** modify the SQL to append the LIMIT clause ********************
        $sqlquery.=$limit_clause;

        //*************** execute the 2 queries ************************************
        $this->sqlquery=$sqlquery;
        $this->sqlresult=$this->db->getAll($sqlquery,null,null,null,MDB2_FETCHMODE_ASSOC);
        if (PEAR::isError($this->sqlresult)) {
            die("<pre>".$this->sqlresult->getUserinfo()."</pre>");
	}
        $this->totalrecs_nolimit=getonefromdb($this->db,"SELECT FOUND_ROWS()");
    }

    function setOrderClause($order_text) {
        // *** SET the order_clause for the SQL statement for this webpage (right now)
        // **** ORDER of next selected view is done in setHeadingsHtml()
        $debug=TRUE;
        $debug=FALSE;
        if ($debug) println("<b>Entering 'setOrderClause' method</b>");

        // ********** get all the headings[sqlout] ****** can do this with DB object later !!!
        $this->setHeadingsSqlout();

        
        // *** find the direction of the sort, fix up the sort variable
        if (substr($order_text,0,1)=='-') {
            $order_text_unsigned=substr($order_text,1);
            $order_direction='DESC';
        } else {
            $order_text_unsigned=$order_text;
            $order_direction='ASC';
        }

        //************ find the $order value ******************
        $key = array_search($order_text_unsigned,$this->headings['text']);
        if ($debug) {
            if ($key===FALSE) {
                println("key===FALSE");
            } else {
                println("key!==FALSE, key=$key");
                println("order_text=$order_text, order_text_unsigned=$order_text_unsigned, order_direction=$order_direction");

                echo "<b>headings = </b><pre>"; print_r($this->headings); echo "</pre>";
            }
        }
        if ($key===FALSE) { //***** if not in the list, give them the first heading
            $orderby_sqlout=reset(($this->headings['sqlout']));
            //while (substr($orderby_sqlout,-7)=='_noshow') {
            //    $orderby_sqlout=next($this->headings['sqlout']);
            //}
            $key=key($this->headings['sqlout']);
            $order_text_unsigned=$this->headings['text'][$key];
        } else {
            $orderby_sqlout = $this->headings['sqlout'][$key];
        }

        $this->caption['text']=$this->caption['text'].' ordered by '.$order_text_unsigned;
        $order_clause=" ORDER BY $orderby_sqlout";
        if ($order_direction=='DESC') {
            $this->caption['text'].=' descending';
            $order_clause.=' '.$order_direction;
        }

        if ($debug) {
            println("orderby_sqlout=$orderby_sqlout");
            println("<b>Exiting 'setOrderClause' method</b>");
        }
        return ($order_clause);
    }

    function setHeadingsSqlout() {
        // ********** get all the headings[sqlout] ****** can do this with DB object later !!!
        foreach ($this->headings['sqlin'] as $key => $value) {
            $pos = strrpos($value," ");
            if ($pos===FALSE) {
                $this->headings['sqlout'][$key]=$this->headings['sqlin'][$key];
            } else {
                $this->headings['sqlout'][$key]=substr($this->headings['sqlin'][$key],$pos+1);
            }
        }
    }

    function setHeadingsHtml($module) {
        // ************** set the corresponding headings[html] for the headings[text] *****************
        $this->module=$module;
        foreach ($this->headings['text'] as $key => $value) {
            $temp_array=$this->gets['array'];
            $temp_array['order']=$value; //****** over write the order GET parm with the text heading
            if ( (isset($_GET['order'])) AND ($_GET['order']==$value) ){  //*** prepend a '-' for a reverse sort
                $temp_array['order']='-'.$temp_array['order'];
            }
            $temp_array['offsetrecord']=0; //****** over write the order GET parm with offsetrecord=0, a new sort means a new record
            $this->headings['html'][$key]=thissite_ahref($module.buildurlgetstring($temp_array),$this->headings['text'][$key]);
        }
   }

}

?>
