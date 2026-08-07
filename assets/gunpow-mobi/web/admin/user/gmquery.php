<?php
include_once($_SERVER['DOCUMENT_ROOT'] . '/config.php');
if ($_POST) {
 $checknum = trim ( poststr ( 'checknum' ) );
 $quid = trim ( poststr ( 'qu' ) );
 $qu = $quarr [$quid];
 $uid = trim ( poststr ( 'uid' ) );
 $dbname = $qu ['db_name'];
 $srvid = $qu ['srvid'];
 $mail = $qu ['mail'];
 $recharge = $qu ['recharge'];
 $time = time ();
 if ($checknum == $gmcode) {
  if ($quid >= 1) {
   if ($uid != '') {
    $sql = "SELECT * FROM $dbname.game_player WHERE name='" . $uid . "'";
    $result = mysql_query ( $sql, $conn );
    $row = mysql_fetch_array ( $result );
    if ($row ['name'] != '') {
     $actorid = $row ['id'];
	 $actorname = $row ['name'];
	//$logfile = "gm.log";
    //$userid = $row ['id'];
    // $platform = $row ['platform'];
     if ($_POST ['type']) {
      $type = trim ( $_POST ['type'] );
      switch ($type) {
       case 'charge' :
        $goodsid = trim ( $_POST ['num'] );
        if ($goodsid == '') {
         exit ( 'Lỗi nạp!' );
        }
		$d = array(
                    'playerId'=>$actorid,
                    'id'=>$goodsid,
                    'channelid'=>$srvid
                );
			$data = http_post($recharge,http_build_query($d));
            $res = json_decode($data,true);	
        if ($res['msg'] == 0) {
		//$fh = fopen($logfile,'a') or die("cant open file");
		//fwrite($fh,"Gui thanh cong 20.000.000 Kim Cuong cho nhan vat: ".$actorname.", ID: ".$actorid.", Thoi gian: ".date('Y-m-d H:i:s'));
		//fwrite($fh,"\r\n");
		//fclose($fh);
         exit ( "Gửi thành công!" );
        } else {
         exit ( "Gửi thất bại!" );
        }
        /*
         * 邮件
         */
        break;
       case 'daoju' :
        $item = $_POST ['item'];
        $itemnum = $_POST ['num'];
        if ($item != "") {
         
         if ($itemnum != "") {
         } else {
          exit ( 'Vui lòng nhập số lượng!' );
         }
        } else {
         exit ( 'Vui lòng chọn một mục!' );
        }
        $d = array(
                    'playerId'=>$actorid,
                    'mailTitle'=>"GM",
                    'mailContent'=>"Thư từ GM, kiểm tra và nhận",
                    'itemInfo' => "[{\"propid\":$item,\"pronum\":$itemnum}]"
                );
			$data = http_post($mail,http_build_query($d));
            $res = json_decode($data,true);	
			//echo $data;
        if ($res['msg'] == 0) {
		//$fh = fopen($logfile,'a') or die("cant open file");
		//fwrite($fh,"Gui thanh cong ItemID: ".$item.", So luong: ".$itemnum." cho nhan vat: ".$actorname.", ID: ".$actorid.", Thoi gian: ".date('Y-m-d H:i:s'));
		//fwrite($fh,"\r\n");
		//fclose($fh);
		 exit ( "Thư đã được gửi thành công!" );
        } else {
         exit ( "Gửi thư thất bại!" );
        }
        break;
       default :
        exit ( 'Hệ thống bất thường, vui lòng thử lại!' );
        break;
      }
     } else {
      exit ( 'Loại yêu cầu không tồn tại!' );
     }
    } else {
     exit ( 'Nhân vật không tồn tại!' );
    }
   } else {
    exit ( 'Lỗi ID nhân vật!' );
   }
  } else {
   exit ( 'Lỗi máy chủ!' );
  }
 } else {
  exit ( 'Sai mã GM!' );
 }
} else {
 exit ( 'Yêu cầu không được phép!' );
}