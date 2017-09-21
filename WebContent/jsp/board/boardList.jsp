<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>    
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%!
int rowCountPerPage = 10;
int pageBlockSize = 10;
int currPage = 1;
int totalCount = 0;

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

private List<Map<String, String>> getBoardList(String searchType, String search)throws SQLException, ClassNotFoundException{
	Connection conn = getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	List<Map<String, String>> boardList = new ArrayList<>(); 
	try{
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM (\n");
		sql.append("SELECT A.*, ROWNUM RN FROM (\n");
		
		sql.append("SELECT COUNT(*) OVER () AS TOT_CNT,\n");
		sql.append("	   SEQ,\n");
		sql.append("	   TITLE,\n");
		sql.append("	   CONTENTS,\n");
		sql.append("	   REG_ID,\n");
		sql.append("	   TO_CHAR(REG_DATE, 'YYYY-MM-DD') AS REG_DATE,\n");
		sql.append("	   (SELECT USER_NM FROM CM_USER WHERE USER_ID = BOARD.MOD_ID) AS MOD_ID,\n");
		sql.append("	   TO_CHAR(MOD_DATE, 'YYYY-MM-DD') AS MOD_DATE\n");
		sql.append("  FROM BOARD \n");
		if(search != null){
			if("title".equals(searchType)){
				sql.append(" WHERE TITLE LIKE '%'||?||'%'\n");
				
			}else if("seq".equals(searchType)){
				sql.append(" WHERE SEQ = ?\n");
				
			}else if("contents".equals(searchType)){
				sql.append(" WHERE CONTENTS LIKE '%'||?||'%'\n");
				
			}else if("titleAndContents".equals(searchType)){
				sql.append(" WHERE CONTENTS||' '||TITLE LIKE '%'||?||'%'\n");
				
			}
		}
		
		sql.append(" ORDER BY MOD_DATE DESC, SEQ DESC\n");
		sql.append(") A\n");
		sql.append(") WHERE RN > (? * (? - 1)) AND RN <= (? * ?)"); // 
		
		pstmt = conn.prepareStatement(sql.toString());
		
		int parameterIndex = 0;
		if(search != null){
			if("title".equals(searchType) || "contents".equals(searchType) || "titleAndContents".equals(searchType)){
				pstmt.setString(1, search);
				parameterIndex++;
				
			}else if("seq".equals(searchType)){
				pstmt.setInt(1, Integer.parseInt(search));
				parameterIndex++;
				
			}
		}
		
		pstmt.setInt(++parameterIndex, rowCountPerPage);
		pstmt.setInt(++parameterIndex, currPage);
		pstmt.setInt(++parameterIndex, rowCountPerPage);
		pstmt.setInt(++parameterIndex, currPage);
		
		System.out.print("쿼리실행 : ");
		System.out.println(sql.toString());
		System.out.print("파라미터 : ");
		System.out.println(search);
		
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			if(totalCount == 0)
				totalCount = rs.getInt(1);
			
			Map<String, String> board = new HashMap<>();
			board.put("seq"     , String.valueOf(rs.getInt(2)));
			board.put("title"   , rs.getString(3));
			board.put("contents", rs.getString(4));
			board.put("regId"   , rs.getString(5));
			board.put("regDate" , rs.getString(6));
			board.put("modId"   , rs.getString(7));
			board.put("modDate" , rs.getString(8));
			
			System.out.println(board.toString());
			boardList.add(board);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(rs    != null) try{rs.close();   }catch(Exception ex){}
		if(pstmt != null) try{pstmt.close();}catch(Exception ex){}
		if(conn  != null) try{conn.close(); }catch(Exception ex){}
	}
	
	return boardList;
}
%>
<%
	if(request.getParameter("currPage") != null)
		currPage = Integer.parseInt(request.getParameter("currPage"));
	
	String search     = request.getParameter("search");
	String searchType = request.getParameter("searchType");
	
	List<Map<String, String>> boardList = getBoardList(searchType, search);
	
	int totalPage = 1, pageBlockSize = 10, startPage = 1,  endPage = 1;

	if(boardList.size() > 0){
		totalPage = new Double(Math.ceil(new Double(totalCount)/pageBlockSize)).intValue();
		
		if(pageBlockSize < currPage){
			startPage = (currPage/pageBlockSize) * 10 + 1;
		}
		
		endPage = startPage + pageBlockSize - 1;
		if(endPage > totalPage) endPage = totalPage;
		
	}
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 목록</title>
<style>
html body {width:100%; height:100%;}
table {width:100%; border: 1px solid #555; border-spacing: 0px;}
table tr th, td {border: 1px solid #555; height: 40px; text-align: left; padding-left: 5px; padding-right: 15px;}
table tr td a {color: blue; cursor: pointer;}
input, select {width:100%; height: 25px; padding-left:5px;}
button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold; cursor: pointer;}

.search table {width:100%; border: 0px; border-spacing: 0px; margin-bottom:10px;}
.search table tr td {border: 1px solid #555; height: 40px; text-align: left; padding-left: 5px; padding-right: 15px;}

.list table {width:100%; border: 1px solid #555;; border-spacing: 0px; margin-bottom:10px;}
.list table tr th, td {border: 1px solid #555; height: 30px; padding-left: 5px; padding-right: 5px; text-align: center;}

.page {text-align: center;}
.page ul {display: inline-block;}
.page li {display: inline;}

.page li > a {font-weight: normal; cursor: pointer;}
</style>

<script>
	function fn_read(seq){
		location.href = "boardRead.jsp?seq=" + seq;
	}
	
	function fn_search(page){
		var search     = document.getElementById("search").value; 
		var searchType = document.getElementById("searchType").value; 
		
		var url = "boardList.jsp?search=" + search + "&searchType=" + searchType;
		if(page != null){
			url += "&currPage=" + page;
		}
		
		location.href = url;  
	}
	
	function fn_write(){
		location.href = "boardWrite.jsp";
	}
</script>

</head>
<body>
<div style="width:800px; margin-top:10px; margin-left: auto; margin-right: auto;">
	<h3>게시판 목록</h3>
	<div class="search">
		<table>
			<colgroup>
				<col width="150px"/>
				<col width="*"/>
				<col width="80px"/>
				<col width="80px"/>
			</colgroup>
			<tr>
				<td>
					<select id="searchType" name="searchType">
						<option value="title" <%= ("title".equals(searchType) ? "selected" : "")%> >제목</option>
						<option value="seq" <%= ("seq".equals(searchType) ? "selected" : "")%> >글번호</option>
						<option value="contents" <%= ("contents".equals(searchType) ? "selected" : "")%> >내용</option>
						<option value="titleAndContents" <%= ("titleAndContents".equals(searchType) ? "selected" : "")%> >제목+내용</option>
					</select>
				</td>
				<td><input id="search" name="search" type="text" value="<%=(search == null) ? "" : search%>"></td>
				<td style="padding-right:0px; border: 0px;"><button onclick="fn_search();">조회</button></td>
				<td style="padding-right:0px; border: 0px;"><button onclick="fn_write();">글쓰기</button></td>
			</tr>
		</table>
	</div>
	<div class="list">
		<table>
			<colgroup>
				<col width="80px"/>
				<col width="*"/>
				<col width="100px"/>
				<col width="100px"/>
			</colgroup>
			<tr>
				<th>글번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
			</tr>
			<% 
			for(int i=0; i<boardList.size(); i++){ 
				Map<String, String> board = boardList.get(i);
			%>
			<tr>
				<td><%= board.get("seq") %></td>
				<td style="text-align: left;"><a onclick="fn_read(<%= board.get("seq") %>);"><%= board.get("title") %></a></td>
				<td><%= board.get("modId") %></td>
				<td><%= board.get("modDate") %></td>
			</tr>
			<%} %>
		</table>
	</div>
	<div class="page">
		<ul>
	<%  if(endPage > 1 && currPage > 1){ %>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(1);">&lt;&lt;</a></li>
	<% 
		}
		if(endPage > pageBlockSize){
	%>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(<%= startPage - 10 %>);">&nbsp;&lt;&nbsp;</a></li>
	<% 
		} 
		for(int i= startPage; i <= endPage; i++){
	%>
			<li><%= (currPage == i) ? "<strong>" + i + "</strong>" : "<a onclick=\"fn_search(" + i + ");\">" + i + "</a>" %></li>
	<%
		}
		
		if(totalPage > endPage){ 
	%>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(<%= startPage + 10 %>);">&nbsp;>&nbsp;</a></li>
	<% 
		}
		if(totalPage > currPage){
	%>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(<%= totalPage %>);">>></a></li>
	<% } %>
		</ul>
	</div>
</div>
</body>
</html>