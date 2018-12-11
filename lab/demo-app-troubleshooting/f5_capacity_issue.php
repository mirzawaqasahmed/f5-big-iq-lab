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
	$myfile = fopen("$filename", "r") or die("Unable to open file!");
	flock($myfile, LOCK_EX);
	$n=fgets($myfile);
	echo "<img src='f5-logo.png' alt='f5-logo.png' />";
	echo "<p/>$n users connected to the application.";
	flock($myfile, LOCK_UN);
	fclose($myfile);
	$n++;
	$myfile = fopen("$filename", 'w') or die('Cannot open file:  '.$filename);
	flock($myfile, LOCK_EX);
	fwrite($myfile, $n);
	flock($myfile, LOCK_UN);
	fclose($myfile);
} else {
	echo "The file $filename does not exist";
	$myfile = fopen("$filename", 'w') or die('Cannot open file:  '.$filename);
	flock($myfile, LOCK_EX);
	$n="1";
	echo "<img src='f5-logo.png' alt='f5-logo.png' />";
	echo "<p/>$n users connected to the application.";
	fwrite($myfile, $n);
	flock($myfile, LOCK_UN);
	fclose($myfile);
}

# If number over 100, send error 500
if($n >= 20)
{
	echo "<img src='f5-logo-black-and-white.png' alt='f5-logo-black-and-white.png' />";
	echo "<p/>$n users connected to the application.";
	http_response_code(503);
}

if($n >= 25)
{
	# delete database
	unlink("$filename");
	sleep(10);
}

?>

</body>
</html>