<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="co.kr.ucs.bean.UserBean" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
html body {width:100%; height:100%;}
table {width:100%; border: 1px solid #555; border-spacing: 0px;}
table tr th, td {border: 1px solid #555; height: 40px; text-align: center; padding-left: 5px; padding-right: 15px;}
input {width:100%; height: 25px; padding-left:5px;}
button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold;; cursor: pointer;}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function(){
		$('#btn_save').on('click', function(){
			fn_save();
		})
	})
	function fn_save(){
		var title = $("#title");
		if(title.val() == null || title.val() == ''){
			alert('제목을 입력하세요');
			title.focus();
			return;
		}
		
		var params = {
			'title'    : title.val(),
			'contents' : $('#contents').val()
		}
		$.ajax({
			url:'/board/boardWrite',
			data: JSON.stringify(params),
			type:'POST',
			contentType:'application/json;charset=utf-8',
			dataType:'json',
			error:function(xhr,status,msg){
				alert("상태값 :" + status + " Http에러메시지 :"+msg);
			},
			success:function(data){
				if(data['error']){
					alert(data['error']);
					return;
				}
				
				history.back();
			}
		});
	}
</script>
</head>
<body>
<div style="width:800px; margin-top:10px; margin-left: auto; margin-right: auto;">
	<h3>게시판 입력</h3>
	<table>
		<colgroup>
			<col width="150px"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<th>제목*</th>
			<td><input id="title" name="title" type="text"></td>
		</tr>
		<tr>
			<th>내용</th>
			<td style="height: 300px; padding-top:10px; padding-bottom:5px;">
				<textarea id="contents" name="contents" style="width:100%; height: 100%;"></textarea>
			</td>
		</tr>
	</table>
	<div style="text-align:center; margin-top:10px;">
		<button id="btn_save">저장</button>
		<button onclick="javascript:history.back();">목록</button>
	</div>
</div>
</body>
</html>