<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/header.php');
if (!isset($_SESSION['username'])) {
	 header('Location: /dang-nhap');
}
if (@$_GET['act'] == "do") {
	include_once "../config.php";
    $username = $_SESSION['username'];
	$accountname = trim($_POST['accountname']); //Tên nhân vật
	$giftcode = trim($_POST['code']); //Mã Giftcode
	$serverId = trim($_POST['serverid']); //Server ID
	$qu = $quarr[$serverId];
    $dbname = $qu['db_name'];
    $mail = $qu['mail'];
	
	$giftCodeQuery = "SELECT * FROM $database.gift_code WHERE code = '{$giftcode}' LIMIT 1";
	$result_giftCodeQuery = @mysql_query($giftCodeQuery);
	$row_giftCodeQuery = @mysql_fetch_array($result_giftCodeQuery);
	if (empty($accountname) || empty($serverId) || empty($giftcode)) {
        print "<script>alert('Thông tin không hợp lệ -1!');history.go(-1)</script>";
        exit;
	}
	if ($row_giftCodeQuery === false) {
        print "<script>alert('Giftcode không hợp lệ -2!');history.go(-1)</script>";
        exit;
	}
	if ($row_giftCodeQuery['is_limited'] == 1 && $row_giftCodeQuery['limit_number'] <= 0) {
	    print "<script>alert('Giftcode đã được sử dụng quá số lần cho phép!');history.go(-1)</script>";
        exit;
	}
	date_default_timezone_set('Asia/Ho_Chi_Minh');
	if (!empty($row_giftCodeQuery['expired_date']) && strtotime($row_giftCodeQuery['expired_date']) < time()) {
	    print "<script>alert('Giftcode đã hết hạn!');history.go(-1)</script>";
        exit;
	}
	if ($row_giftCodeQuery['server'] != $serverId && $row_giftCodeQuery['server'] != 'all') {
	    print "<script>alert('Giftcode không hợp lệ!');history.go(-1)</script>";
        exit;
	}
	$giftCodeId = $row_giftCodeQuery['id'] . "_" . $serverId;
	$checkUsedCode = "SELECT * FROM $database.`used_code` WHERE (`username` = '$username' AND `gift_code` = '".$giftCodeId."') LIMIT 1";
	$result_checkUsedCode = @mysql_query($checkUsedCode);
	$row_checkUsedCode = @mysql_fetch_array($result_checkUsedCode);
	if ($row_checkUsedCode !== false) {
		print "<script>alert('Giftcode đã được sử dụng!');history.go(-1)</script>";
        exit;
	}
		$title = $row_giftCodeQuery['subject'];
		$content = $row_giftCodeQuery['content'];
		$itemid = $row_giftCodeQuery['item'];
		$itemnum = 1; //Số lượng item muốn tặng
		$check_accname = "SELECT * FROM $dbname.game_player WHERE name = '$accountname'";
		$result_accname = @mysql_query($check_accname);
		$row_accname = mysql_fetch_array ($result_accname);
		$actorid = $row_accname['id'];
		$data = array(
            'playerId'=>$actorid,
            'mailTitle'=>$title,
            'mailContent'=>$content,
            'itemInfo' => "[{\"propid\":$itemid,\"pronum\":$itemnum}]"
        );
		$send = http_post($mail,http_build_query($data));
        $res = json_decode($send,true);
		if ($res['msg'] == 0) {
		@mysql_query("INSERT INTO $database.`used_code` (`username`, `gift_code`) VALUES ('$username', '$giftCodeId')"); //Lưu used
		print "<script>alert('Đổi Giftcode thành công, hãy kiểm tra hòm thư!');history.go(-1)</script>";
		exit;
	    }else{
		print "<script>alert('Đổi Giftcode thất bại 1, vui lòng kiểm tra lại!');history.go(-1)</script>";
		exit;			
	    }
}
?>
<div class="row">
    <div class="col-md-4 col-md-offset-4" >
        <form action="?act=do" method="post">
		<div class="panel panel-default">
			<div class="panel-body"><h3>Nhận Giftcode</h3></div>
			<div class="alert alert-warning" role="alert">
			<strong>Để nhận code vui lòng liên hệ Fanpage</strong>
			</div>
			<div class="form-group has-feedback">
			<div class="form-group has-feedback">
			<div class="input-group">
			<span class="input-group-addon">Máy chủ</span>
			<select id="serverid" name="serverid" class="form-control">
            <?php
				foreach($quarr as $key=>$value){
					if($value['hidde']!=true){
					echo '<option value="'.$key.'">'.$value['name'].'</option>';
				    }
				}
			?>
            </select>
			</div>
			<label class="err"></label>
			</div>
			<div class="form-group has-feedback">
			<div class="input-group">
			<span class="input-group-addon">Nhân vật</span>
			<input name="accountname" id="accountname" type="text" class="form-control" placeholder="Nhập tên nhân vật">
			</div>
			<label class="err"></label>
			</div>
			<div class="form-group has-feedback">
			<div class="input-group">
			<span class="input-group-addon">Code</span>
			<input name="code" type="text" class="form-control" placeholder="Nhập mã Giftcode">
			</div>
			<label class="err"></label>
			</div>
			<button type="submit" class="btn btn-default btn-block">Nhận Giftcode</button>
			<a class="btn btn-link" href="/nap-the">Nạp Thẻ</a>
			</div>
		</form>
		</div>
	</div>
</div>
<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/footer.php'); ?>