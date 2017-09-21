<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인</title>
<style type="text/css">
	html body {width:100%; height:100%;}
	table {width:100%; border: 1px solid #555; border-spacing: 0px;}
	table tr th, td {border: 1px solid #555; height: 40px; text-align: left; padding-left: 5px; padding-right: 15px;}
	input {width:100%; height: 25px; padding-left:5px;}
	button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold;}
</style>

<script type="text/javascript">
	function fn_login(){
		var userId = document.getElementById("userId");
		var userPw = document.getElementById("userPw");
		
		if(userId.value == null || userId.value == ''){
			alert('아이디를 입력하세요');
			userId.focus();
			return;
		}
		
		if(userPw.value == null || userPw.value == ''){
			alert('비밀번호를 입력하세요');
			userPw.focus();
			return;
		}
		
		document.forms[0].action = "signProcess.jsp";
		document.forms[0].submit();
	}
	
	function fn_signUp(){
		location.href = "signUp.jsp";
	}
</script>
</head>
<body>
<div style="width:400px; height: 200px; margin-top:150px; margin-left: auto; margin-right: auto;">
	<h3>로그인</h3>
	<form method="post">
		<input type="hidden" name="process" value="signin">
		<table>
			<colgroup>
				<col width="150px"/>
				<col width="*"/>
				<col width="150px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>아이디*</th>
				<td><input id="userId" name="userId" type="text"></td>
			</tr>
			<tr>
				<th>비밀번호*</th>
				<td><input id="userPw" name="userPw" type="password"></td>
			</tr>
		</table>
	</form>
	<div style="text-align:center; margin-top:10px;">
		<button onclick="fn_login();">로그인</button>
		<button onclick="fn_signUp();">회원가입</button>
	</div>
</div>
</body>
</html>