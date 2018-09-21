<!-- Page to install in hackazon container under /var/www/hackazon -->
<!-- f5-logo-black-and-white.png and f5-logo-black-and-white.png to be uploaded under /var/www/hackazon -->
<!DOCTYPE html>
<html lang='en'>
<head>
    <title>F5 App Troubleshooting Browser Issue</title>
</head>
<body>

<?php

$browser = $_SERVER['HTTP_USER_AGENT'];

if (strpos($browser, 'Chrome') !== false) {
	sleep(30);
	echo "<img src='f5-logo.png' alt='f5-logo.png' />";
	echo "<p/>30s delay load page for Chrome browser only.";
}else{
	echo "<img src='f5-logo-black-and-white.png' alt='f5-logo-black-and-white.png' />";
	echo "<p/>no delay for all other browsers.";
}

echo "<p/>";
echo $_SERVER['HTTP_USER_AGENT'];

?>

</body>
</html>