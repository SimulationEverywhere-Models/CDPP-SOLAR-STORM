#!/usr/bin/php
<?php
// Works as of PHP 5.3 (5.3.20)
// download:  http://windows.php.net/download/#php-5.3
// installer for windows

$page = file_get_contents('index.html');
//$page = file_get_contents('http://www.ips.gov.au/Solar/1/4');

$tokens = preg_split("/[\s,]+/", $page);

for ($i = 0; $i < count($tokens); $i++)
{ 
    if($tokens[$i]=="Bz:"){
		$Bzindex=$i+1;
		$i=count($tokens);
	}
}

$myFile = "Bz.txt";
$fh = fopen($myFile, 'w');
$stringData = $tokens[$Bzindex];
fwrite($fh, $stringData);
fclose($fh);

//echo "Bz was saved"; 
?>
