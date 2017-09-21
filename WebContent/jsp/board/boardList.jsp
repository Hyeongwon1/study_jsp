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
input, select {width:100%; height: 25px; padding-left:5px;}
button {width:100px;mrgin-top:10px; font-size: 14px; font-weight:bold;}

.search table {width:100%; border: 0px; border-spacing: 0px; margin-bottom:10px;}
.search table tr td {border: 1px solid #555; height: 40px; text-align: left; padding-left: 5px; padding-right: 15px;}

.list table {width:100%; border: 1px solid #555;; border-spacing: 0px; margin-bottom:10px;}
.list table tr th, td {border: 1px solid #555; height: 30px; padding-left: 5px; padding-right: 5px; text-align: center;}

.page {text-align: center;}
.page ul {display: inline-block;}
.page li {display: inline;}

.page li > a {font-weight: bold; cursor: pointer;}
</style>
</head>
<body>
<div style="width:800px; margin-top:10px; margin-left: auto; margin-right: auto;">
	<h3>게시판 목록</h3>
	<div class="search">
		<table>
			<colgroup>
				<col width="150px"/>
				<col width="*"/>
				<col width="150px"/>
			</colgroup>
			<tr>
				<td>
					<select>
						<option>제목</option>
						<option>글번호</option>
						<option>내용</option>
						<option>제목+내용</option>
					</select>
				</td>
				<td><input id="search" type="text"></td>
				<td style="text-align:center; border: 0px;"><button>조회</button></td>
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
				<th>내용</th>
				<th>작성자</th>
				<th>작성일</th>
			</tr>
			<tr>
				<td>1</td>
				<td style="text-align: left;">게시판 목록을 작성하자</td>
				<td>홍길동</td>
				<td>2017.09.13</td>
			</tr>
			<tr>
				<td>2</td>
				<td style="text-align: left;">게시판 목록</td>
				<td>길동이</td>
				<td>2017.09.12</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</table>
	</div>
	<div class="page">
		<ul>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a>&lt;&lt;</a></li>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a>&nbsp;&lt;&nbsp;</a></li>
			<li><a>1</a></li>
			<li><a>2</a></li>
			<li><a>3</a></li>
			<li><a>4</a></li>
			<li><a>5</a></li>
			<li><a>6</a></li>
			<li><a>7</a></li>
			<li><a>8</a></li>
			<li><a>9</a></li>
			<li><a>10</a></li>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a>&nbsp;>&nbsp;</a></li>
			<li style="padding: 0px 8px; border: 2px solid #555;"><a>>></a></li>
		</ul>
	</div>
</div>
</body>
</html>