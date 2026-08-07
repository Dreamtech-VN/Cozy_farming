<?php
@session_start();
header("Content-Type:text/html; charset=utf-8");
$username = $_SESSION['username'];
include_once "config.php";
$sql = "SELECT * FROM $database.tab_account WHERE user_name = '$username'";
$result = @mysql_query($sql);
$row = @mysql_fetch_array($result);
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $webtitle; ?></title>
	<link rel="shortcut icon" href="/themes/jxsjmid/Content/favicon.ico">
	<meta property="og:url" content="" />
	<meta property="og:type" content="article" />
	<meta property="og:title" content="<?php echo $webtitle; ?>" />
	<meta property="og:description" content="GunPow Mobi phiên bản cày cuốc, server ổn định lâu dài, tỷ lệ nạp x5000 VNG. Hỗ trợ tân thủ lên VIP, không bán đồ HK" />
	<meta property="og:image" content="/themes/jxsjmid/Content/og-image.png" />
	<meta property="fb:app_id" content="" />
    <link href="/themes/jxsjmid/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="/themes/jxsjmid/Content/site.css" rel="stylesheet" type="text/css" />
    <script src="/themes/jxsjmid/Scripts/jquery-1.10.2.min.js"></script>
    <script src="/themes/jxsjmid/Scripts/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/themes/jxsjmid/Content/font-awesome.min.css" />
    <script src="/themes/jxsjmid/Scripts/moment.js"></script>
    <script src="/themes/jxsjmid/Scripts/app.js"></script>
</head>
<body>
	<div class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/"><span class="glyphicon glyphicon-home"></span></a>
				<?php if(@$_SESSION['username']){ ?>
				<div class="navbar-brand">
                     <span class="balance">Chào bạn, <span class="banlance"><?php echo $row['user_name'];?></span></span>
                </div>
				<?php }else{ ?>
				<?php } ?>
            </div>
            <div class="navbar-collapse collapse">
                <ul class="nav navbar-nav navbar-right">
				    <?php if(@$_SESSION['username']){ ?>
				    <li><a href="/giftcode"><span class="glyphicon glyphicon-gift"></span> GiftCode</a></li>
                    <li><a href="/nap-the"><span class="glyphicon glyphicon-credit-card"></span> Nạp thẻ</a></li>
                        <li class="dropdown">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#"><span class="glyphicon glyphicon-user"></span> Tài khoản <span class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="/doi-mat-khau"><span class="glyphicon glyphicon-lock"></span> Đổi mật khẩu</a></li>
                                    <li><a href="/thoat"><span class="glyphicon glyphicon-log-out"></span> Thoát</a></li>
                                </ul>
                        </li>
					    <?php }else{ ?>
                        <li><a href="/dang-ky"><span class="glyphicon glyphicon-registration-mark"></span> Đăng Ký</a></li>
                        <li><a href="/dang-nhap"><span class="glyphicon glyphicon-log-in"></span> Đăng Nhập</a></li>
				        <?php } ?>
                </ul>
            </div>
        </div>
    </div>
<div class="container" style="padding-top:20px;">
