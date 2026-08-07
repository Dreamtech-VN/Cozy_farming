<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/header.php');
if (!isset($_SESSION['username'])) {
	 header('Location: /dang-nhap');
}
?>
<h2>Thông tin tài khoản</h2>
<div class="row">
    <div class="col col-md-2 col-xs-3"><img class="ava" src="/themes/jxsjmid/Content/logo.png"  /></div>
    <div class="col col-md-10 col-xs-9">
        <div class="row">Tên tài khoản</div>
        <div class="row">
            <h3><span class="banlance"><?php echo $row['user_name'];?></span></h3>
            <a href="/nap-the" class="btn btn-link" style="display:inline;">Nạp thẻ</a>
			<a href="/giftcode"" class="btn btn-link" style="display:inline;">Giftcode</a>
        </div>
    </div>
</div>
<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/footer.php'); ?>