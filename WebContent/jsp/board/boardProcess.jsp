<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>    
<%@ page import="co.kr.ucs.service.BoardService"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	request.setCharacterEncoding("UTF-8");
	
	String userId   = request.getParameter("userId");
	String title    = request.getParameter("title");
	String contents = request.getParameter("contents");
	
	BoardService boardService = new BoardService();
	String error = boardService.saveBoard(title, contents, userId);
	
 %>
 <script>
 	<% if(error != null){%>
 		alert("엘러발생 : " + <%= error %>);
 		history.back();
 	<% } else {%>
 		alert("저장 하였습니다.");
 		location.href = 'boardList.jsp';
 	<% }%>
 </script>
 