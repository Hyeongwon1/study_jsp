<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>    
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>    
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

private Map<String, String> getBoard(int seq)throws SQLException, ClassNotFoundException{
	Connection conn = getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	Map<String, String> board = new HashMap<>();
	try{
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT SEQ,\n");
		sql.append("	   TITLE,\n");
		sql.append("	   CONTENTS,\n");
		sql.append("	   REG_ID,\n");
		sql.append("	   TO_CHAR(REG_DATE, 'YYYY-MM-DD') AS REG_DATE,\n");
		sql.append("	   (SELECT USER_NM FROM CM_USER WHERE USER_ID = BOARD.MOD_ID) AS MOD_ID,\n");
		sql.append("	   TO_CHAR(MOD_DATE, 'YYYY-MM-DD') AS MOD_DATE\n");
		sql.append("  FROM BOARD \n");
		sql.append(" WHERE SEQ = ?\n");
		
		pstmt = conn.prepareStatement(sql.toString());
		
		pstmt.setInt(1, seq);
		
		System.out.print("쿼리실행 : ");
		System.out.println(sql.toString());
		System.out.print("파라미터 : ");
		System.out.println(seq);
		
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			board.put("seq"     , String.valueOf(rs.getInt(1)));
			board.put("title"   , rs.getString(2));
			board.put("contents", rs.getString(3));
			board.put("regId"   , rs.getString(4));
			board.put("regDate" , rs.getString(5));
			board.put("modId"   , rs.getString(6));
			board.put("modDate" , rs.getString(7));
			
			System.out.println(board.toString());
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(rs    != null) try{rs.close();   }catch(Exception ex){}
		if(pstmt != null) try{pstmt.close();}catch(Exception ex){}
		if(conn  != null) try{conn.close(); }catch(Exception ex){}
	}
	
	return board;
}
%>
<%
	int seq = Integer.parseInt(request.getParameter("seq"));
	Map<String, String> board = getBoard(seq);
%>
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
			<td><%= board.get("modId") %></td>
			<th>작성일</th>
			<td><%= board.get("modDate") %></td>
		</tr>
		<tr>
			<th>제목</th>
			<td colspan="3" style="text-align:left;"><%= board.get("title") %></td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="3" style="height: 300px; padding-top:10px; padding-bottom:5px; text-align: left; vertical-align: top;">
				<%= board.get("contents") %> 
			</td>
		</tr>
	</table>
	<div style="text-align:center; margin-top:10px;">
		<button onclick="history.back();">목록</button>
	</div>
</div>
</body>
</html>
