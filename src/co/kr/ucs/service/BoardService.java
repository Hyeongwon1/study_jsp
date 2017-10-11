package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import co.kr.ucs.bean.BoardBean;
import co.kr.ucs.bean.SearchBean;
import co.kr.ucs.dao.DBConnectionPool;
import co.kr.ucs.dao.DBConnectionPoolManager;
import co.kr.ucs.dao.DBManager;

public class BoardService {
	private int totalCount = 0;
	private int rowCountPerPage = 10;
	
	DBConnectionPoolManager dbPoolManager = DBConnectionPoolManager.getInstance();
	DBConnectionPool dbPool;
	
	public BoardService() {
		dbPoolManager.setDBPool(DBManager.getUrl(), DBManager.getId(), DBManager.getPw());
		dbPool = dbPoolManager.getDBPool();
	}
	
	public List<BoardBean> getBoardList(SearchBean searchBean)throws SQLException{
		List<Map<String, String>> list = getBoardList(searchBean.getSearchType(), searchBean.getSearch(), searchBean.getCurrPage());
		
		List<BoardBean> boardList = new ArrayList<>();
		for(Map<String, String> data : list) {
			boardList.add(mapToBean(data));
		}

		return boardList;
	}
	
	public List<Map<String, String>> getBoardList(String searchType, String search, int currPage)throws SQLException{
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<Map<String, String>> boardList = new ArrayList<>(); 
		try{
			conn = dbPool.getConnection();
			
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
			if(search != null && search.trim().length() > 0){
				if("title".equals(searchType)){
					sql.append(" WHERE TITLE LIKE '%'||?||'%'\n");
					
				}else if("seq".equals(searchType)){
					search = search.replaceAll("[^0-9]", "");
					if(search != null && search.length() > 0) {
						sql.append(" WHERE SEQ = ?\n");
					}
					
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
			if(search != null && search.trim().length() > 0){
				if("title".equals(searchType) || "contents".equals(searchType) || "titleAndContents".equals(searchType)){
					pstmt.setString(1, search);
					parameterIndex++;
					
				}else if("seq".equals(searchType) && search.length() > 0){
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
			throw e;
			
		}finally{
			dbPool.freeConnection(conn);
			DBManager.close(rs, pstmt);
		}
		
		return boardList;
	}
	
	public void saveBoard(String title, String contents, String userId) throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try{
			conn = dbPool.getConnection();
			
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
		}catch(SQLException e){
			throw e;
		}finally{
			dbPool.freeConnection(conn);
			DBManager.close(null, pstmt);
		}
	}
	
	public BoardBean getBoardBean(int seq)throws SQLException {
		return mapToBean(getBoard(seq));
	}
	
	private BoardBean mapToBean(Map<String, String> board) {
		BoardBean bean = new BoardBean();
		
		bean.setSeq(Integer.parseInt(board.get("seq")));
		bean.setTitle(board.get("title"));
		bean.setContents(board.get("contents"));
		bean.setRegId(board.get("regId"));
		bean.setRegDate(board.get("regDate"));
		bean.setModId(board.get("modId"));
		bean.setModDate(board.get("modDate"));
		
		return bean;
	}
	
	public Map<String, String> getBoard(int seq)throws SQLException{
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		Map<String, String> board = new HashMap<>();
		try{
			conn = dbPool.getConnection();
			
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT SEQ,\n");
			sql.append("	   TITLE,\n");
			sql.append("	   CONTENTS,\n");
			sql.append("	   REG_ID,\n");
			sql.append("	   TO_CHAR(REG_DATE, 'YYYY-MM-DD') AS REG_DATE,\n");
			sql.append("	   NVL((SELECT USER_NM FROM CM_USER WHERE USER_ID = BOARD.MOD_ID), MOD_ID) AS MOD_ID,\n");
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
			throw e;
			
		}finally{
			dbPool.freeConnection(conn);
			DBManager.close(rs,  pstmt);
		}
		
		return board;
	}

	public int getRowCountPerPage() {
		return rowCountPerPage;
	}

	public void setRowCountPerPage(int rowCountPerPage) {
		this.rowCountPerPage = rowCountPerPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
}
