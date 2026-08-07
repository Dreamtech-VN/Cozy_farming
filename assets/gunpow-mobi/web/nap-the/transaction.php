<?php
session_start();
error_reporting(E_ALL^E_NOTICE);
error_reporting(E_ERROR);
header('Content-Type: text/html; charset=utf-8');
define('CORE_API_HTTP_USR', 'merchant_19150');
define('CORE_API_HTTP_PWD', '19150sAmK2OgUS4YI570ZXJrDvi24FfwTN1');
date_default_timezone_set('Asia/Ho_Chi_Minh');
include 'GB_API.php';
include_once "../config.php";
$username = $_SESSION['username'];
$serverId = trim($_POST['serverid']);
$accountname = trim($_POST['accountname']);
$qu = $quarr[$serverId];
$dbname = $qu['db_name'];
$srvid = $qu['srvid'];
$recharge = $qu['recharge'];
$seri = isset($_POST['txtseri']) ? $_POST['txtseri'] : '';
$sopin = isset($_POST['txtpin']) ? $_POST['txtpin'] : '';
$gia = isset($_POST['chonthe']) ? $_POST['chonthe'] : '';
$mang = isset($_POST['chonmang']) ? $_POST['chonmang'] : '';

if($mang=='1')         {$ten = "Viettel";}
else if($mang=='2')    {$ten = "Mobifone";}
else if($mang == '5')  {$ten = "Vcoin";}
else if($mang=='4')    {$ten = "Gate";}
else if($mang=='6')    {$ten = "Vietnammobile";}       
else $ten = "Vinaphone";

$merchant_id = __REDACTED__; // mã đăng kí GB
$api_user = __REDACTED__; // user đăng kí GB
$api_password = __REDACTED__; // pass user đăng ký GB

$napthe = file_get_contents("http://sv.gamebank.vn/api/card2?merchant_id=".$merchant_id."&api_user=".trim($api_user)."&api_password=".trim($api_password)."&pin=".trim($sopin)."&seri=".trim($seri)."&card_type=".intval($mang)."&price_guest=".$gia."&note=".urlencode($username)."");
$info_card = str_replace("\xEF\xBB\xBF",'',$napthe);
$info_card = json_decode($napthe);
$code = $info_card->code; // mã lỗi dạng số
$msg = $info_card->msg; // mã dạng chữ
$info_card = $info_card->info_card; // mệnh giá thẻ 
	
$time = time();

if($code === 0 && $info_card >= 10000) {
    $amount = $info_card;
	
    switch($amount) {
        case 10000: $pay_code_id = 1; break;
        case 20000: $pay_code_id = 3; break;
        case 50000: $pay_code_id = 4; break;
        case 100000: $pay_code_id = 5; break;
        case 200000: $pay_code_id = 6; break;
        case 500000: $pay_code_id = 8; break;
    }

    // Chuyển Coin vào tài khoản
	$check_accname = "SELECT * FROM $dbname.game_player WHERE name = '$accountname'";
	$result_accname = @mysql_query($check_accname);
	$row_accname = mysql_fetch_array ($result_accname);
	$actorid = $row_accname['id'];
	$data = array(
        'playerId'=>$actorid,
        'id'=>$pay_code_id,
        'channelid'=>$srvid
    );
	$pay = http_post($recharge,http_build_query($data));
    $res = json_decode($pay,true);
	//Luu card ra log:
	$file = "carddung.log";
	$fh = fopen($file,'a') or die("cant open file");
	fwrite($fh,"Tai khoan: ".$username.", Loai the: ".$ten.", Menh gia: ".$amount.",Ma the: ".$sopin.", Seri: ".$seri.", Thoi gian: ".date('Y-m-d H:i:s'));
	fwrite($fh,"\r\n");
	fclose($fh);
	if ($amount>0){
	echo '<script>alert("Bạn đã nạp thành công thẻ '.$ten.' mệnh giá '.$amount.', vui lòng vào lại game để kiểm tra!");location.href="/nap-the";</script>';
	}else{
	echo '<script>alert("Có lỗi xảy ra, vui lòng liên hệ với hỗ trợ!");location.href="/nap-the";</script>';	
	}
}
else{
    echo 'Status Code:' . $code . '<hr >';
    $error = $msg;
	echo $error;
    $file = "cardsai.log";
    $fh = fopen($file,'a') or die("cant open file");
    fwrite($fh,"Tai khoan: ".$username.", Ma the: ".$sopin.", Seri: ".$seri.", Noi dung loi: ".$error.", Thoi gian: ".date('Y-m-d H:i:s'));
    fwrite($fh,"\r\n");
    fclose($fh);
    echo '<script>alert("Thông tin thẻ cào không hợp lệ!");location.href="/nap-the"</script>';
}