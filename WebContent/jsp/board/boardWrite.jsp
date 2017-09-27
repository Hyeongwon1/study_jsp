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

<script type="text/javascript">
	function fn_save(){
		var title = document.getElementById("title");
		if(title.value == null || title.value == ''){
			alert('제목을 입력하세요');
			title.focus();
			return;
		}
		
		document.forms[0].action = "<%= request.getContextPath() %>/board/boardWrite";
		document.forms[0].submit();
	}
</script>
</head>
<body>
<div style="width:800px; margin-top:10px; margin-left: auto; margin-right: auto;">
	<h3>게시판 입력</h3>
	<form method="post">
		<input type="hidden" name="userId" value="<%= ((UserBean)session.getAttribute("SESSION_USER")).getUserId() %>">
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
	</form>
	<div style="text-align:center; margin-top:10px;">
		<button onclick="fn_save();">저장</button>
		<button onclick="javascript:history.back();">목록</button>
	</div>
</div>
</body>
</html>