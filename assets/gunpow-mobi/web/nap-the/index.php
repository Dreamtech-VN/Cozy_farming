<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/header.php');
if (!isset($_SESSION['username'])) {
	 header('Location: /dang-nhap');
}
?>
<div class="row">
	<a href="https://www.facebook.com/netdevgame/" target="_blank"><button class="btn btn-info btn-block my-4" type="submit">Liên hệ chuyển khoản bằng ATM, Momo +20% giá trị nạp thẻ</button></a>
	<br />
	<p><strong style="color: #0000ff;"><strong><span style="color: #ff0000;"><span style="color: #0000ff;">Chú ý:&nbsp;</span></span><span style="color: #ff0000;">&nbsp;Gặp lỗi trong quá trình nạp thẻ vui lòng liên hệ <a href="https://www.facebook.com/netdevgame/" target="_blank">Fanpage</a> để được hỗ trợ</span></strong></strong></p>
</div>
<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
	<form action="transaction.php" method="post" class="text-center border border-light p-5">
	    <label>Chọn máy chủ:</label>
		<select id="serverid" name="serverid" class="form-control">
            <?php
				foreach($quarr as $key=>$value){
					if($value['hidde']!=true){
					echo '<option value="'.$key.'">'.$value['name'].'</option>';
				    }
				}
			?>
        </select>
		<label>Nhân vật:</label>
		<input type="text" value="" id="accountname" name="accountname" class="form-control mb-4" placeholder="Nhập tên nhân vật">
		<label>Chọn Loại Thẻ:</label>
		<select name="chonmang" class="form-control mb-4 dropdown-primary" style="height: auto;">
			<option value="0"> -- Chọn loại thẻ  -- </option>
			<option value="1">Viettel</option>
			<option value="2">Mobifone</option>
			<option value="3">Vinaphone</option>
			<option value="4">GATE (FPT)</option>
		</select>
		<label>Chọn Mệnh Giá: <strong style="color:red">(Hãy chọn đúng mệnh giá)</strong></label>
		<select name="chonthe" class="form-control mb-4" style="height: auto;">
			<option value=""> -- Chọn đúng mệnh giá -- </option>
			<option value="10000">10000 VNĐ</option>
			<option value="20000">20000 VNĐ</option>
			<option value="50000">50000 VNĐ</option>
			<option value="100000">100000 VNĐ</option>
			<option value="200000">200000 VNĐ</option>
			<option value="500000">500000 VNĐ</option>
		</select>
		<label>Số Seri:</label>
		<input type="text" value="" id="txtseri" name="txtseri" class="form-control mb-4" placeholder="Số Seri">
		<label>Mã Thẻ:</label>
		<input type="text" value="" id="txtpin" name="txtpin" class="form-control mb-4" placeholder="Mã Thẻ">
		<br />
		<button name="napthe" class="btn btn-info btn-block my-4" type="submit">Nạp thẻ</button>
	</form>
</div>
<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
	<img src="https://sv.gamebank.vn/trang-thai-he-thong-3" />	
</div>
</div>
<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/footer.php'); ?>