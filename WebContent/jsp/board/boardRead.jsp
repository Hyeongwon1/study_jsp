<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 상세</title>
<style>
html body {width:100%; height:100%;}
table {width:100%; border: 1px solid #555; border-spacing: 0px;}
table tr th, td {border: 1px solid #555; height: 40px; text-align: center; padding-left: 5px; padding-right: 15px;}
input {width:100%; height: 25px; padding-left:5px;}
button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold;; cursor: pointer;}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
	$(function(){
		var seq = '<%= request.getParameter("seq")%>';
		$.ajax({
			url:'/board/boardRead',
			data: JSON.stringify({'seq' : seq}),
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
				
				for(var key in data['board']){
					$('#' + key).html(data['board'][key]);
				}
			}
		});
	})
	
</script>
</head>
<body>
<div style="width:800px; margin-top:10px; margin-left: auto; margin-right: auto;">
	<h3>게시판 상세</h3>
	<table>
		<colgroup>
			<col width="150px"/>
			<col width="*"/>
			<col width="150px"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<th>작성자</th>
			<td id="modId"></td>
			<th>작성일</th>
			<td id="modDate"></td>
		</tr>
		<tr>
			<th>제목</th>
			<td colspan="3" style="text-align:left;" id="title"></td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="3" style="height: 300px; padding-top:10px; padding-bottom:5px; text-align: left; vertical-align: top;" id="contents">
			</td>
		</tr>
	</table>
	<div style="text-align:center; margin-top:10px;">
		<button onclick="history.back();">목록</button>
	</div>
</div>
</body>
</html>
