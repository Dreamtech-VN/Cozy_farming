<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/header.php');
if (isset($_SESSION['username'])) {
	 header('Location: /thong-tin');
}
?>
<h1>Vui lòng đăng ký trong game</h1>
<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/footer.php'); ?>