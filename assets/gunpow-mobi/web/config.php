<?php
error_reporting(0);
header("Content-type: text/html; charset=utf-8");
ini_set('date.timezone','Asia/Ho_Chi_Minh');
session_start();
$quarr = array (
 '10001' => array (
  'mail' => 'http://192.168.1.69:6680/SendMailServlet_hzj7?',//邮件
  'recharge' => 'http://192.168.1.69:6680/OrderServlet_hzj7?',//充值
  'db_ip' => '127.0.0.1',
  'db_port' => 3306,
  'db_user' => 'root',
  'db_pswd' => '__REDACTED__',
  'db_name' => 'ddd2_world_s1',
  'srvid' => '0',
  'name'=>'GunPow-S1',
  'hidde'=>false
 ),
);

$webtitle = 'GunPow Mobi';
$db_type = 'mysql';
$db_charset = 'utf8';
$db_host = 'localhost';
$db_username = 'root';
$db_password = __REDACTED__;
$database = 'ddd2_account';
$conn = @mysql_connect("$db_host","$db_username","$db_password") or die ("cant connect db");
@mysql_select_db("$database",$conn) or die ("cant select db");
mysql_query("set names UTF8");

$gmcode = __REDACTED__;//GM码

function poststr($str){
 if(isset($_POST[$str])){
  return $_POST[$str];
 }
die("this link server do not exist".$str);
}
function http_post($url, $data_string) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'X-AjaxPro-Method:ShowList',
            'Content-Type: application/x-www-form-urlencoded; charset=utf-8',
            'Content-Length: ' . strlen($data_string))
    );
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
}
?>