<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>主页</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/modal.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-dialog.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/schapp-main.css" type="text/css" />
<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>  
    <script src="${pageContext.request.contextPath}/js/html5shiv.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/respond.min.js"></script>
<![endif]-->
<script src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap-dialog.min.js"></script>


<script src="${pageContext.request.contextPath}/js/common.js"></script>
<style type="text/css">
.modal-header-sch {
	color:black;
    background-color: white;
 }

</style>
<script type="text/javascript">
var rows_data,row;
$(document).ready(function() {
	$("#banner-nav li:first").addClass('active');
	$("#btn_user_add").click(function(){
		showEditModal(0);
	});
	$("#btn_user_save").click(trySaveUser);
	$.ajax({
 		type:'POST',
 		url:'${pageContext.request.contextPath}/sys/users/allStudents.json',
 		data:{},
 		success: function(data){
 			if (data.error){
 				alert(data.error);
 				return;
 			} 
 			renderStudentsTable(data);
 			
 		}
 	});
	
});
function renderStudentsTable(data){
	var $t=$('#students_table');
	rows_data=data.data;		 
	var opts= 
		" <button class='edit btn btn-default btn-sm'><i class='glyphicon glyphicon-edit'></i> 编辑</button>"
    	+" <button class='dele btn btn-default btn-sm'><i class='glyphicon glyphicon-trash'></i> 删除</button>"
	$.each(rows_data,function(i,row){
		var arr=[row.id,row.code,row.username,row.department,row.major,opts]
		$('#students_table').append(generate_html_tr(arr));
		$('#students_table button.edit:last').click(function(){
			showEditModal(row.id);
		});
		$('#students_table button.dele:last').click(function(){
			showDeleteItemConfirmDialog(row.id);
		});
	});
    	
 
}
function showEditModal(row_id){
	 //$('#user_edit_modal form input[name]').val('');
	 if (row_id){
		 $('#user_edit_modal form').fillForm(getRowDataById(rows_data,row_id));
	 }else{
		 $('#user_edit_modal form input[name]').val('');
		 $('#user_edit_modal form input[name="main_role_name"]').val('student');
	 }	
	 
	 $('#user_edit_modal').modal('show');
}

function generate_html_tr(cells){
	var s='';
	for (var i in cells){
		s+='<td>'+cells[i]+'</td>';
	}
	return '<tr>'+s+'</tr>';
}
function getRowDataById(rows_data,row_id){
	for (var i in rows_data){
		if (rows_data[i].id==row_id) return rows_data[i];
	}
	return null;
}

function showDeleteItemConfirmDialog(item_id){
	BootstrapDialog.show({
        title: '警告',
        message: '确定要删除该条目吗？',
        buttons: [{
            label: '确定',
            cssClass: 'btn-primary',
            action: function(dialog) {
            	tryDeleteUser(item_id);
            }
        }, {
            label: '取消',
            action: function(dialog) {
                dialog.close();
            }
        }]
    });
}
function tryDeleteUser(uid){
	$.ajax({
 		type:'POST',
 		dataType : 'json',
 		url: "${pageContext.request.contextPath}/sys/user/delete.do",
 		data:{"userId":uid},
 		success: function(data){
 			if (!data.error){
 				alert("操作成功！");
 				location.reload();
 			}else{
 				alert("操作失败: "+data.error);
 			} 			
 		}
 		,error : function(xhr,st,err){alert("ERROR: "+st+err); }
 	});
}
function trySaveUser(){
	var new_psd = $("#user_edit_modal input[name='new_psd']").val();
	var new_psd2 = $("#user_edit_modal input[name='new_psd2']").val();
	if (new_psd2 != new_psd) {
		alert("两次密码输入不一致！");
		return;
	}
	
	var post_data= $('#user_edit_modal').readForm();
	if (new_psd) post_data['password'] = new_psd;	
	var url = post_data['id'] ? 
			 "${pageContext.request.contextPath}/sys/user/update.do"
			:"${pageContext.request.contextPath}/sys/user/create.do";
	$.ajax({
 		type:'POST',
 		dataType : 'json',
 		url: url,
 		data:post_data,
 		success: function(data){
 			if (!data.error){
 				alert("操作成功！");
 				//location.reload();
 			}else{
 				alert("操作失败: "+data.error);
 			}
 			
 		}
 	});
}

</script>
<style type="text/css">
</style>
</head>
<body>

	<%@ include file="div-banner.jsp"%>
	<div class="schapp-body">
		<div class="schapp-navi-breadcrumb">
			<ol class="breadcrumb">
				<li><a href="${pageContext.request.contextPath}/home">首页</a></li>
				<%-- 		<li><a href="${pageContext.request.contextPath}/users">人员信息管理</a></li>		 --%>
				<li class="active">人员管理</li>
			</ol>
		</div>

		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">学生信息管理</h3>				
			</div>			
			<div class="panel-body">
				<div class="bottom-right">
					<button type="button" class="btn btn-default bottom-left-btn" id="btn_user_add">
						<i class="glyphicon glyphicon-plus"></i>&nbsp;新增学生账户
					</button>				
				</div>
				<table class="table table-condensed" id="students_table">
					<thead>
						<tr>
							<th>#</th>
							<th>学号</th>
							<th>姓名</th>
							<th>院系</th>
							<th>专业</th>
							<th>操作</th>
						</tr>
					</thead>
					 
				</table>


			</div>
		</div>
	</div>

<div id="user_edit_modal" class="modal" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header modal-header-sch">
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        <h4 class="modal-title">用户信息</h4>
      </div>
      <div class="modal-body">
      	<form class="form-horizontal" role="form">
      	<div class="form-group">
				<label class="col-sm-2 control-label">角色</label>
				<p class="col-sm-10"><label class="control-label">学生</label></p>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">姓名*</label>
				<p class="col-sm-10"><input name="username" class=" form-control" placeholder="姓名"></p>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">学号*</label>
				<p class="col-sm-10"><input name="code" class="form-control" placeholder="学号"></p>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">院系</label>
				<p class="col-sm-10"><input name="department" class="form-control" placeholder="院系"></p>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">专业</label>
				<p class="col-sm-10"><input name="major" class="form-control" placeholder="专业"></p>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">新密码</label>
				<p class="col-sm-10"><input name="new_psd" type="password" class="form-control" placeholder="新密码"></p>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">重复密码</label>
				<p class="col-sm-10"><input name="new_psd2" type="password" class="form-control" placeholder="重复密码"></p>
			</div>
			<input name="id" type="hidden">
			<input name="password" type="hidden">
			<input name="main_role_name" type="hidden" value="student">
		</form>     
      </div><!-- /.modal-body -->
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="btn_user_save" >保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
      </div><!-- /.modal-footer -->
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
 </div>
</body>
</html>