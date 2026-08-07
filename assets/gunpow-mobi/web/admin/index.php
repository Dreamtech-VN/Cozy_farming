<?php
$t = time ();
?>
<!DOCTYPE html>
<html>   
<?php include 'head.php';?>    
<body>
 <div class="container">
   <br>
   <div class="row">
     <div class="container-fluid">
  <div class="modal-dialog">
    <div class="modal-content">
      <ul class="breadcrumb">				
				<li>
					 <b>Gunpow Mobi - GMPanel</b>
				</li>				
			</ul>
      <div class="modal-body">
   <div class="form-horizontal" role="form">
                <div class="form-group">
                    <div class="col-sm-10">
                        <input type="password" id="checknum" name="checknum" class="form-control" maxlength="16" value="" placeholder="Nhập mã GM" required>
                    </div>
                </div>
				<div class="form-group">
                    <div class="col-sm-10">
                        <select id="qu" name="qu" class="form-control selectpicker" data-size="5" title="Chọn máy chủ" required>
                            <?php
						include_once($_SERVER['DOCUMENT_ROOT'] . '/config.php');
						foreach($quarr as $key=>$value){
							if($value['hidde']!=true){
								echo '<option value="'.$key.'">'.$value['name'].'</option>';
						}
						}
							
						?>
                        </select>
                    </div>
                </div>
				<div class="form-group">
                    <div class="col-sm-10">
                        <input type="text" id="uid" name="uid" class="form-control" value="" placeholder="Nhập tên nhân vật" required>
                    </div>
                </div>
                				
				<div class="form-group">
                    <div class="col-sm-10">					
                   	<select id="chargenum" name="chargenum" class="form-control selectpicker" data-size="5" title="Nhập số Kim cương" required>
                            <option value="1">1000000 Kim cương</option>
							<option value="3">2000000 Kim cương</option>
							<option value="4">5000000 Kim cương</option>
							<option value="5">10000000 Kim cương</option>
							<option value="6">15000000 Kim cương</option>
							<option value="8">35000000 Kim cương</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-danger btn-block" onclick="chargebtn()">Nạp Kim Cương</button>					
                    </div>					
                </div>				
                <div class="form-group">
                    <div class="col-sm-10">
                        <select id="mailid" name="mailid" class="selectpicker show-tick form-control" data-live-search="true" data-size="5" title="Vật phẩm">
                       <?php
                       $file = fopen("user/item.txt", "r");
                       while(!feof($file))
                       {
                       $line=fgets($file);
                       $txts=explode(';',$line);
                       echo '<option value="'.$txts[0].'">'.$txts[1].'</option>';
                       }
                       fclose($file);
                       ?>
                        </select>
                    </div>
                </div>
				<div class="form-group">
                    <div class="col-sm-10">					    
                        <input type="text" id="mailnum" name="mailnum" class="form-control" min="0" max="9999" value="" placeholder="Nhập số lượng item" required>
                    </div>
                </div>			
                <div class="form-group">
                    <div class="col-sm-10">						
						<button type="submit" class="btn btn-primary" onclick="send_mail()">Gửi mail</button>						
                    </div>					
                </div>			
            </div>
      </div>
    </div>
  </div>
     </div>
   </div>
 </div>
 <script src="js/msg.js?v=<?php echo $t;?>"></script>
</body>
</html>