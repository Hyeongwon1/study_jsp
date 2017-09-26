<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="co.kr.ucs.service.BoardService"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	int seq = Integer.parseInt(request.getParameter("seq"));
	BoardService boardService = new BoardService();
	Map<String, String> board = boardService.getBoard(seq);
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
