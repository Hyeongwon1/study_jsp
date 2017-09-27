<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="co.kr.ucs.bean.BoardBean"%>
<%@ page import="co.kr.ucs.bean.SearchBean"%>
<%@ page import="co.kr.ucs.service.BoardService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	int totalPage = 1, pageBlockSize = 10, startPage = 1,  endPage = 1;


	List<BoardBean> boardList = (List<BoardBean>)request.getAttribute("boardList");
	SearchBean searchBean = (SearchBean)request.getAttribute("searchBean");
	
	int totalCount = (Integer)request.getAttribute("totalCount");
	int currPage = searchBean.getCurrPage();
	
	String search = searchBean.getSearch();
	String searchType = searchBean.getSearchType();
	
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
		location.href = "<%=request.getContextPath()%>/board/boardRead?seq=" + seq;
	}
	
	function fn_search(page){
		var search     = document.getElementById("search").value; 
		var searchType = document.getElementById("searchType").value; 
		
		var url = "<%=request.getContextPath()%>/board/boardList?search=" + search + "&searchType=" + searchType;
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
				BoardBean board = boardList.get(i);
			%>
			<tr>
				<td><%= board.getSeq() %></td>
				<td style="text-align: left;"><a onclick="fn_read(<%= board.getSeq() %>);"><%= board.getTitle() %></a></td>
				<td><%= board.getModId() %></td>
				<td><%= board.getModDate()%></td>
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