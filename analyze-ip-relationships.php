<!-- Take a list of IPs from file ip-list.txt and analyze for relationships -->

<?php

$file='ipblacklistmaster';
$closeness=32768;	// 	65536 	131072;
$minrelated=6;

$sorted=array();
$ips=file($file);  

echo '<pre style="white-space:pre-wrap;">',count($ips)," IPs <br>\r\n";   flush(); 

foreach ($ips as $ip) {
	$ip=ip2long(trim($ip)); if ($ip) { $ip=sprintf('%u',$ip); } else { continue; }
	foreach ($sorted as $sortkey=>$array) {
		if (isset($array[$ip])) { continue 2; }
		foreach ($array as $key=>$ignore) {
			if (abs($key-$ip)<$closeness) { $sorted[$sortkey][$ip]=''; continue 3; }
		}
	} $sorted[][$ip]=0;
}

unset($ips); foreach ($sorted as $key=>$array) { if (count($array)<$minrelated) { unset($sorted[$key]); } }
echo count($sorted)," IP groups ($closeness apart, with minimum $minrelated related)<br>\r\n";   

foreach ($sorted as $array) {	
	ksort($array,SORT_NUMERIC); 
	foreach ($array as $key=>$ignore) { echo long2ip((float)$key),"\t"; }	
	echo "<br>\r\n";  
}
