<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/header.php');
if (isset($_SESSION['username'])) {
	 header('Location: /thong-tin');
}
if ( @$_GET['act'] == "do" )
{
    // Dùng hàm addslashes() để tránh SQL injection, dùng hàm md5() để mã hóa password
    $username = addslashes( $_POST['username'] );
    $password =  addslashes( $_POST['password'] );
	//$password = md5($password);
    // Lấy thông tin của username đã nhập trong table account
    $sql_query = @mysql_query("SELECT * FROM $database.tab_account WHERE user_name='{$username}' LIMIT 1");
    $member = @mysql_fetch_array( $sql_query );
    // Nếu username này không tồn tại thì....
    if ( @mysql_num_rows( $sql_query ) <= 0 )
    {
        print "<script>alert('Tài khoản không tồn tại!');window.location.href='/dang-nhap';</script>";
        exit;
    }
    // Nếu username này tồn tại thì tiếp tục kiểm tra mật khẩu
    if ( $password != $member['password'] )
    {
        print "<script>alert('Tài khoản hoặc mật khẩu không chính xác!');window.location.href='/dang-nhap';</script>";
        exit;
    }
    // Khởi động phiên làm việc (session)
    @$_SESSION['username'] = $member['user_name'];
    // Đăng nhập thành công chuyển hướng đến
    print "<script>window.location.href='/thong-tin';</script>";
}
else
{
// Form đăng nhập
print <<<EOF

EOF;
}
?>
<div class="row">
    <div class="col-md-4 col-md-offset-4" >
        <form action="?act=do" method="post">
            <div class="panel panel-default">
                <div class="panel-body"><h3>Đăng nhập hệ thống</h3></div>
				<div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                        <input name="username" type="text" class="form-control" placeholder="Tài Khoản" required autofocus>
                    </div>
                    <label class="err"></label>
                </div>
                <div class="form-group has-feedback">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                        <input type="password" class="form-control" name="password" placeholder="Mật Khẩu" required>
                    </div>
                    <label class="err"></label>
                </div>
                <button type="submit" class="btn btn-default btn-block" >Đăng nhập</button>
				<a class="btn btn-link" href="/dang-ky">Đăng ký</a>
            </div>
        </form>
    </div>
</div>
<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/footer.php'); ?>