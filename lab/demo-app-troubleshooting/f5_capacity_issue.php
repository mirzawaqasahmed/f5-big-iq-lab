<!-- Page to install in hackazon container under /var/www/hackazon/web -->
<!-- f5-logo-black-and-white.png and f5-logo-black-and-white.png to be also uploaded under /var/www/hackazon/web -->
<!DOCTYPE html>
<html lang='en'>
<head>
    <title>F5 App Troubleshooting Inability to handle production data capacities</title>
</head>
<body>

<?php

$filename = 'database.txt';

if (file_exists($filename)) {
	echo "The file $filename exists";
	$n=file_get_contents('database.txt');
	# Increasing "number of connection to the DB"
	$n++;
	$handle = fopen($filename, 'w') or die('Cannot open file:  '.$filename);
	fwrite($handle, $n);
	fclose($handle);
	echo "<img src='f5-logo.png' alt='f5-logo.png' />";
	echo "<p/>$n users connected to the application.";
} else {
	echo "The file $filename does not exist";
	$handle = fopen($filename, 'w') or die('Cannot open file:  '.$filename);
	$n="1"
	fwrite($handle, $n);
	fclose($handle);
}

# If number over 1000, send error 500
if($n >=1000)
{
	http_response_code(500);
	# Reset number of DB connection to 1
	$handle = fopen($filename, 'w') or die('Cannot open file:  '.$filename);
	$n="1"
	fwrite($handle, $n);
	fclose($handle);
}

?>

</body>
</html>