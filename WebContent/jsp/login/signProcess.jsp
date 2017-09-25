<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="co.kr.ucs.dao.DBManager"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
private int getExistsUser(String userId)throws SQLException, ClassNotFoundException{
	return getExistsUser(userId, null);
}

private int getExistsUser(String userId, String userPw)throws SQLException, ClassNotFoundException{
	int count = 0;
	DBManager dbManager = new DBManager();
	Connection conn = dbManager.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT COUNT(*) FROM CM_USER WHERE USER_ID = ?");
		
		if(userPw != null){
			sql.append(" AND USER_PW = ?");
		}
		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, userId);
		if(userPw != null){
			pstmt.setString(2, userPw);
		}
		
		rs = pstmt.executeQuery();
		
		System.out.print("쿼리실행 : ");
		System.out.println(sql.toString());
		System.out.print("파라미터 : ");
		System.out.println(userId);
		
		if(rs.next()) count = rs.getInt(1);
		
		System.out.println("결과 : " + count);
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		dbManager.close(rs, pstmt, conn);
	}
	
	return count;
	
}
private boolean signUp(String userId, String userNm, String userPw, String email)throws SQLException, ClassNotFoundException{
	DBManager dbManager = new DBManager();
	Connection conn = dbManager.getConnection();
	PreparedStatement pstmt = null;
	try{
		StringBuffer sql = new StringBuffer();
		sql.append("INSERT INTO CM_USER (");
		sql.append("USER_ID, USER_NM, USER_PW, EMAIL");
		sql.append(")VALUES(");
		sql.append("?, ? ,?, ?)");
		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, userId);	
		pstmt.setString(2, userNm);	
		pstmt.setString(3, userPw);	
		pstmt.setString(4, email);
		
		System.out.print("쿼리실행 : ");
		System.out.println(sql.toString());
		System.out.print("파라미터 : ");
		System.out.println(userId + ", "  + userNm + ", "  + userPw + ", "  + email );
		
		pstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
		return false;
	}finally{
		dbManager.close(null, pstmt, conn);
	}
	
	return true;
}
%>
<%
	request.setCharacterEncoding("UTF-8");
	// 처리구분
	String process = request.getParameter("process");

	String userId = request.getParameter("userId");
	String userPw = request.getParameter("userPw");
	
	String result = new String();
	
	// 회원가입
	if("signup".equals(process)){
		int count = 0;
		if((count = getExistsUser(userId)) > 0){
			result = "existUser";
			
		}else{
			String userNm = request.getParameter("userNm");
			String email  = request.getParameter("email");
			
			if(signUp(userId, userNm, userPw, email)){
				result = "successSignup";	
			}else{
				result = "failSignup";
			}
		}
		
	// 로그인
	}else if("signin".equals(process)){
		int count = 0;
		if((count = getExistsUser(userId)) > 0){
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