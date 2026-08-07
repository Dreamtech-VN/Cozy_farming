<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/header.php');
if (!isset($_SESSION['username'])) {
	 header('Location: /dang-nhap');
}
$conn = @mysqli_connect("localhost","root","__REDACTED__","ddd2_account");
if ( @$_GET['act'] == "do" )
{
    // Dùng hàm addslashes() để tránh SQL injection, dùng hàm md5() để mã hóa password
    $username = $_SESSION['username'];
	$oldpassword = addslashes( $_POST['oldpassword'] );
    $newpassword =  addslashes( $_POST['newpassword'] );
	$renewpassword = addslashes( $_POST['renewpassword'] );
	if ( empty($newpassword) || empty($renewpassword) || empty($oldpassword) ) {
        print "<script>alert('Vui lòng nhập đầy đủ thông tin!');window.location.href='/doi-mat-khau';</script>";
        exit;
    }
	// Kiểm tra xem hai mật khẩu đã khớp chưa
	if ( $newpassword != $renewpassword ) {
        print "<script>alert('Hai mật khẩu không khớp nhau!');window.location.href='/doi-mat-khau';</script>";
        exit;
    }
	if ( $oldpassword == $newpassword ) {
        print "<script>alert('Mật khẩu mới trùng mật khẩu cũ!');window.location.href='/doi-mat-khau';</script>";
        exit;
    }
    // Lấy thông tin của username đã nhập trong table
    $sql_query = @mysql_query("SELECT * FROM $database.tab_account WHERE user_name='{$username}' AND password='{$oldpassword}' LIMIT 1");
    // Nếu thông tin không trùng khớp thì....
    if ( @mysql_fetch_array( $sql_query ) === false )
    {
        print "<script>alert('Mật khẩu cũ không đúng!');window.location.href='/doi-mat-khau';</script>";
        exit;
    }else{
		$sql_intquery = @mysqli_query($conn,"UPDATE $database.tab_account SET password = '{$newpassword}' WHERE user_name = '{$username}'");
		if ($sql_intquery !== false) {
			// Xóa phiên làm việc đăng nhập lại (session)
			session_destroy();
			// Thành công chuyển hướng đến
			print "<script>alert('Đổi mật khẩu thành công, đăng nhập lại!');window.location.href='/dang-nhap';</script>";
		}else{
			print "<script>alert('Có lỗi xảy ra vui lòng liên hệ GM!');window.location.href='/doi-mat-khau';</script>";
		}
        exit;
	}
}
else
{
// Form
print <<<EOF

EOF;
}
?>
<div class="row">
    <div class="col-md-4 col-md-offset-4" >
        <form action="?act=do" method="post">
            <div class="panel panel-default">
                <div class="panel-body"><h3>Đổi mật khẩu</h3></div>
				<div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                        <input type="password" class="form-control" name="oldpassword" placeholder="Mật Khẩu cũ" required>
                    </div>
                    <label class="err"></label>
                </div>
				<div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                        <input type="password" class="form-control" name="newpassword" placeholder="Mật Khẩu mới" required>
                    </div>
                    <label class="err"></label>
                </div>
				<div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                        <input type="password" class="form-control" name="renewpassword" placeholder="Nhập lại Mật Khẩu mới" required>
                    </div>
                    <label class="err"></label>
                </div>
                <button type="submit" class="btn btn-default btn-block">Đổi mật khẩu</button>
                 
            </div>
        </form>
    </div>
</div>
<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/footer.php'); ?>