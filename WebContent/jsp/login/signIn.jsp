<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	session.setAttribute("SESSION_USER_ID", null);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인</title>
<style type="text/css">
	html body {width:100%; height:100%;}
	table {width:100%; border: 1px solid #555; border-spacing: 0px;}
	table tr th, td {border: 1px solid #555; height: 40px; text-align: left; padding-left: 5px; padding-right: 15px;}
	input {width:100%; height: 25px; padding-left:5px;}
	button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold;; cursor: pointer;}
</style>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function(){
		$('#btn_login').on('click', function(){
			fn_login();
		})
		$('#btn_signUp').on('click', function(){
			location.href = "signUp.jsp";
		})
	})
	
	
	function fn_login(){
		var userId = $("#userId");
		var userPw = $("#userPw");
		
		if(userId.val() == null || userId.val() == ''){
			alert('아이디를 입력하세요');
			userId.focus();
			return;
		}
		
		if(userPw.val() == null || userPw.val() == ''){
			alert('비밀번호를 입력하세요');
			userPw.focus();
			return;
		}
		
		var param = {
			'userId' : userId.val(),
			'userPw' : userPw.val()
		}
		
		$.ajax({
			url:'/sign/signin',
			data: JSON.stringify(param),
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
				
				location.href = "<%=request.getContextPath()%>/jsp/board/boardList.jsp";
			}
		});
	}
	
</script>
</head>
<body>
<div style="width:400px; height: 200px; margin-top:150px; margin-left: auto; margin-right: auto;">
	<h3>로그인</h3>
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
	<div style="text-align:center; margin-top:10px;">
		<button id="btn_login">로그인</button>
		<button id="btn_signUp">회원가입</button>
	</div>
</div>
</body>
</html>