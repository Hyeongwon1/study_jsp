<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
private Connection getConnection()throws SQLException, ClassNotFoundException{
	Connection conn = null;
	String url = "jdbc:oracle:thin:@220.76.203.39:1521:UCS";
	String id = "UCS_STUDY";
	String pw = "qazxsw";
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn=DriverManager.getConnection(url,id,pw);
	
	System.out.println("DB 연결성공");
	
	return conn;
}
%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String userId   = request.getParameter("userId");
	String title    = request.getParameter("title");
	String contents = request.getParameter("contents");
	
	String error = "";
	boolean isError = false;
	try{
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		try{
			StringBuffer sql = new StringBuffer();
			sql.append("INSERT INTO BOARD (");
			sql.append("SEQ, TITLE, CONTENTS, REG_ID, REG_DATE, MOD_ID, MOD_DATE");
			sql.append(")VALUES(");
			sql.append("(SELECT NVL(MAX(SEQ), 0) + 1 FROM BOARD),");
			sql.append("?, ?, ?, SYSDATE, ?, SYSDATE)");
			
			pstmt = conn.prepareStatement(sql.toString());
 			pstmt.setString(1, title);	
			pstmt.setString(2, contents);	
			pstmt.setString(3, userId);	
			pstmt.setString(4, userId);
			
			System.out.print("쿼리실행 : ");
			System.out.println(sql.toString());
			System.out.print("파라미터 : ");
			System.out.println(title + ", "  + contents + ", "  + userId);
 			
			pstmt.executeUpdate();
		}catch(Exception e){
			throw e;
		}finally{
			if(pstmt != null) try{pstmt.close();}catch(Exception ex){}
			if(conn  != null) try{conn.close(); }catch(Exception ex){}
		}
	}catch(Exception e){
		e.printStackTrace();
		isError = true;
		error   = e.getMessage();
	}
	
 %>
 <script>
 	<% if(isError){%>
 		alert("엘러발생 : " + <%= error %>);
 		history.back();
 	<% } else {%>
 		alert("저장 하였습니다.");
 		location.href = 'boardList.jsp';
 	<% }%>
 </script>
 