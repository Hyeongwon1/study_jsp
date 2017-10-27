<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
.page li {display: inline; margin-right:10px}

.page li > a {font-weight: normal; cursor: pointer;}
</style>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
	var globalVar = {
		currPage      : 1,
		startPage     : 1,
		endPage       : 1,
		pageBlockSize : 10,
		totalPage     : 1
	}
	
	$(function(){
		$('#btn_write').on('click', function(){
			location.href = "<%=request.getContextPath()%>/jsp/board/boardWrite.jsp";
		})
		
		$('#btn_search').on('click', function(){
			fn_search(1);
		})
		
		fn_search(1);
	})

	function fn_search(page){
		var search     = $("#search").val(); 
		var searchType = $("#searchType").val();
		
		var param = {
			'search'     : $("#search").val(),
			'searchType' : $("#searchType").val(),
			'currPage'   : page
		}
		
		$.ajax({
			url:'/board/boardList',
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
				
				globalVar.currPage = page;
				
				fn_drawBoardList(data);
				fn_drawPaging(data['totalCount']);
				
			}
		});
		
	}
	
	function fn_drawBoardList(data){
		$('.list tbody').empty();
		
		$.each(data['boardList'], function(index, board){
			$('<tr>')
			.append($('<td>').html(board['seq']))
			.append($('<td>').css('text-align', 'left')
					.append($('<a>').attr('onclick', 'fn_read(' + board['seq'] + ');').html(board['title'])))
			.append($('<td>').html(board['modId']))
			.append($('<td>').html(board['modDate']))
			.appendTo($('.list tbody'));
		})
	}
	
	function fn_drawPaging(totalCount){
		globalVar.totalPage = Math.round(Number(totalCount) / globalVar.pageBlockSize);
		globalVar.startPage = parseInt(globalVar.currPage/globalVar.pageBlockSize) * 10 + 1;
		
		globalVar.endPage = globalVar.startPage + globalVar.pageBlockSize - 1;
		if(globalVar.endPage > globalVar.totalPage) globalVar.endPage = globalVar.totalPage;
		
		var pageHtml = '';
		
		if(globalVar.endPage > 1 && globalVar.currPage > 1){
			pageHtml += '<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(1);">&lt;&lt;</a></li>';
		}
		
		if(globalVar.endPage > globalVar.pageBlockSize){
			pageHtml += '<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(' + (globalVar.startPage - 10) + '); ">&nbsp;&lt;&nbsp;</a></li>';
		}
		
		for(var i= globalVar.startPage; i <= globalVar.endPage; i++){
			pageHtml += '<li>' + ((globalVar.currPage == i) ? "<strong>" + i + "</strong>" : "<a onclick=\"fn_search(" + i + ");\">" + i + "</a>") + '</li>';
		}
		
		if(globalVar.totalPage > globalVar.endPage){
			pageHtml += '<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(' + (globalVar.startPage + 10) + ');">&nbsp;>&nbsp;</a></li>';
		}
		
		if(globalVar.totalPage > globalVar.currPage){
			pageHtml += '<li style="padding: 0px 8px; border: 2px solid #555;"><a onclick="fn_search(' + globalVar.totalPage + ');">>></a></li>';
		}
		
		$('.page ul').empty().append(pageHtml);
		
	}
	
	function fn_read(seq){
		location.href = "<%=request.getContextPath()%>/jsp/board/boardRead.jsp?seq=" + seq;
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
						<option value="title">제목</option>
						<option value="seq">글번호</option>
						<option value="contents">내용</option>
						<option value="titleAndContents">제목+내용</option>
					</select>
				</td>
				<td><input id="search" name="search" type="text"></td>
				<td style="padding-right:0px; border: 0px;"><button id="btn_search">조회</button></td>
				<td style="padding-right:0px; border: 0px;"><button id="btn_write">글쓰기</button></td>
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
			<thead>
				<tr>
					<th>글번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<div class="page">
		<ul>
		</ul>
	</div>
</div>
</body>
</html>