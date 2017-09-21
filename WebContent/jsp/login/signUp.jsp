<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입</title>
<style>
	html body {width:100%; height:100%;}
	table {width:100%; border: 1px solid #555; border-spacing: 0px;}
	table tr th, td {border: 1px solid #555; height: 40px; text-align: left; padding-left: 5px; padding-right: 15px;}
	input {width:100%; height: 25px; padding-left:5px;}
	button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold;; cursor: pointer;}
</style>
<script type="text/javascript">
	function fn_signup(){
		var userId        = document.getElementById("userId");
		var userNm        = document.getElementById("userNm");
		var userPw        = document.getElementById("userPw");
		var userPwConfirm = document.getElementById("userPwConfirm");
		var email         = document.getElementById("email");
		
		if(userId.value == null || userId.value == ''){
			alert('아이디를 입력하세요');
			userId.focus();
			return;
		}
		
		if(userNm.value == null || userNm.value == ''){
			alert('이름을 입력하세요');
			userNm.focus();
			return;
		}
		
		if(userPw.value == null || userPw.value == ''){
			alert('비밀번호를 입력하세요');
			userPw.focus();
			return;
		}
		
		if(userPwConfirm.value == null || userPwConfirm.value == ''){
			alert('비밀번호 확인을 입력하세요');
			userPwConfirm.focus();
			return;
		}
		
		if(userPw.value != userPwConfirm.value){
			alert('비밀번호와 비밀번호 확인이 틀립니다.');
			userPw.focus();
			return;
		}
		
		if(email.value == null || email.value == ''){
			alert('이메일을 입력하세요');
			email.focus();
			return;
		}
		
		document.forms[0].submit();
	}
	
	function fn_cancel(){
		history.back();
	}
</script>

</head>
<body>
<div style="width:400px; height: 200px; margin-top:150px; margin-left: auto; margin-right: auto;">
	<h3>회원가입</h3>
	<form method="post" action="signProcess.jsp">
		<input type="hidden" name="process" value="signup">
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
				<th>이름*</th>
				<td><input id="userNm" name="userNm" type="text"></td>
			</tr>
			<tr>
				<th>비밀번호*</th>
				<td><input id="userPw" name="userPw" type="password"></td>
			</tr>
			<tr>
				<th>비밀번호 확인*</th>
				<td><input id="userPwConfirm"  name="userPwConfirm" type="password"></td>
			</tr>
			<tr>
				<th>이메일*</th>
				<td><input id="email" name="email" type="text"></td>
			</tr>
		</table>
	</form>
	<div style="text-align:center; margin-top:10px;">
		<button onclick="fn_signup();">가입</button>
		<button onclick="fn_cancel();">취소</button>
	</div>
</div>
</body>
</html>