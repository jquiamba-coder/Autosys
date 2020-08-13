<?php
echo ' PHP version: ' . phpversion() . PHP_EOL;
$curl_version_arr=curl_version();
$curl_version=$curl_version_arr['version'];
echo 'cURL version: ' . $curl_version . PHP_EOL;

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://www.howsmyssl.com/a/check");
curl_setopt($ch, CURLOPT_SSLVERSION, 6);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
curl_close($ch);

echo ' TLS version: ' . json_decode($response)->tls_version . PHP_EOL;

