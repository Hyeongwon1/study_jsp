<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="co.kr.ucs.service.SignService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("UTF-8");
	// 처리구분
	String process = request.getParameter("process");

	String userId = request.getParameter("userId");
	String userPw = request.getParameter("userPw");
	
	String result = new String();
	
	SignService signService = new SignService();
	
	// 회원가입
	if("signup".equals(process)){
		int count = 0;
		if((count = signService.getExistsUser(userId)) > 0){
			result = "existUser";
			
		}else{
			String userNm = request.getParameter("userNm");
			String email  = request.getParameter("email");
			
			if(signService.signUp(userId, userNm, userPw, email)){
				result = "successSignup";	
			}else{
				result = "failSignup";
			}
		}
		
	// 로그인
	}else if("signin".equals(process)){
		int count = 0;
		if((count = signService.getExistsUser(userId)) > 0){
			session.setAttribute("SESSION_USER_ID", userId);
			
			result = "successSignin";
			
		}else{
			result = "failSignin";
			
		}
	}
%>
<script>
<% if(result.equals("existUser")){ %>
	alert('이미존재하는 아이디입니다.');
	history.back();
	
<% } else if(result.equals("successSignup")){ %>
	alert('회원가입을 완료하였습니다.');
	location.href = 'signIn.jsp';
	
<% } else if(result.equals("failSignup")){ %>
	alert('회원가입 실패.');
	location.href = 'signIn.jsp';

<% } else if(result.equals("successSignin")){ %>
	location.href = '/jsp/board/boardList.jsp';

<% } else if(result.equals("failSignin")){ %>
	alert('로그인 실패.');
	location.href = 'signIn.jsp';

<% } %>
</script>