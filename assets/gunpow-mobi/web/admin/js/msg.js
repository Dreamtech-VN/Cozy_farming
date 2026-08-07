var checknum = '';
var uid = '';
var qu = $('#qu').val();
$('#checknum').change(function() {
    checknum = $(this).val();
});
  $('#uid').change(function(){
	  uid=$.trim($(this).val());
  });
  $('#qu').change(function(){
	  qu=$.trim($(this).val());
  });
$(".selectpicker").selectpicker({
    header:'Mời lựa chọn',
    showIcon:true,
    multipleSeparator:'#',
    maxOptions:4,
    maxOptionsText:'Chọn tối đa 4',
});

/**
角色充值
*/
function chargebtn() {
	if (checknum == '') {
        layer.msg('Vui lòng nhập mã GM!');
        return false;
    }
	  if(uid==''){
		  layer.msg('ID nhân vật không thể trống!');
		  return false;
	  }
	  var chargenum=$('#chargenum').val();
	  if(chargenum==''){
		  layer.msg('Số Kim cương không thể trống!');
		  return false;
	  }	 
	$.ajaxSetup({
		contentType: "application/x-www-form-urlencoded; charset=utf-8"
	});
	$.post("user/gmquery.php", {
		type:'charge',uid:uid,num:chargenum,qu:qu,checknum:checknum		
	},
	function(data) {
		//console.log('data',data);
		layer.msg(data);
		
	});
}
/**
发道具邮件
*/
function send_mail() {
	if (checknum == '') {
        layer.msg('Vui lòng nhập mã GM!');
        return false;
    }
	  if(uid==''){
		  layer.msg('ID nhân vật không thể trống!');
		  return false;
	  }
	  var mailid=$('#mailid').val();
	  if(mailid==''){
		  layer.msg('Vui lòng chọn một mục!');
		  return false;
	  }
	  var mailnum=$('#mailnum').val();
	  if(mailnum=='' || isNaN(mailnum)){
		  layer.msg('Số lượng không thể trống!');
		  return false;
	  }
	  if(mailnum<1 || mailnum>100000){
		  layer.msg('Số lượng từ:1-100000');
		  return false;
	  }
	$.ajaxSetup({
		contentType: "application/x-www-form-urlencoded; charset=utf-8"
	});
	$.post("user/gmquery.php", {
		type:'daoju',uid:uid,item:mailid,num:mailnum,qu:qu,checknum:checknum		
	},
	function(data) {
		layer.msg(data);
		
	});
	
}