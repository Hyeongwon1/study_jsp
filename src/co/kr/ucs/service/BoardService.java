package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
		List<BoardBean> boardList = getBoardList(searchBean.getSearchType(), searchBean.getSearch(), searchBean.getCurrPage());
		return boardList;
	}
	
	public List<BoardBean> getBoardList(String searchType, String search, int currPage)throws SQLException{
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<BoardBean> boardList = new ArrayList<>(); 
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
			
			System.out.println("쿼리실행 : " + sql.toString());
			System.out.println("파라미터 : " + search + ", " + searchType + ", " + currPage);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				if(totalCount == 0)
					totalCount = rs.getInt(1);
				
				BoardBean board = new BoardBean();
				board.setSeq(rs.getInt(2));
				board.setTitle(rs.getString(3));
				board.setContents(rs.getString(4));
				board.setRegId(rs.getString(5));
				board.setRegDate(rs.getString(6));
				board.setModId(rs.getString(7));
				board.setModDate(rs.getString(8));
				
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
	
	public void saveBoard(BoardBean params) throws SQLException {
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
 			pstmt.setString(1, params.getTitle());	
			pstmt.setString(2, params.getContents());	
			pstmt.setString(3, params.getRegId());	
			pstmt.setString(4, params.getModId());
			
			System.out.println("쿼리실행 : " + sql.toString());
			System.out.println("파라미터 : " + params);
 			
			pstmt.executeUpdate();
		}catch(SQLException e){
			throw e;
		}finally{
			dbPool.freeConnection(conn);
			DBManager.close(null, pstmt);
		}
	}
	
	public BoardBean getBoard(BoardBean params)throws SQLException{
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		BoardBean board = new BoardBean();
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
			
			pstmt.setInt(1, params.getSeq());
			
			System.out.println("쿼리실행 : " + sql.toString());
			System.out.println("파라미터 : " + params.getSeq());
			
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				board.setSeq(rs.getInt(1));
				board.setTitle(rs.getString(2));
				board.setContents(rs.getString(3));
				board.setRegId(rs.getString(4));
				board.setRegDate(rs.getString(5));
				board.setModId(rs.getString(6));
				board.setModDate(rs.getString(7));
				
				System.out.println(board);
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
