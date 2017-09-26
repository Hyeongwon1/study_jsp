package co.kr.ucs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import co.kr.ucs.dao.DBManager;

public class BoardService {
	private int totalCount = 0;
	private int rowCountPerPage = 10;
	
	public List<Map<String, String>> getBoardList(String searchType, String search, int currPage)throws SQLException, ClassNotFoundException{
		DBManager dbManager = new DBManager();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<Map<String, String>> boardList = new ArrayList<>(); 
		try{
			conn = dbManager.getConnection();
			
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
			throw e;
			
		}finally{
			if(rs    != null) try{rs.close();   }catch(Exception ex){}
			if(pstmt != null) try{pstmt.close();}catch(Exception ex){}
			if(conn  != null) try{conn.close(); }catch(Exception ex){}
		}
		
		return boardList;
	}
	
	public String saveBoard(String title, String contents, String userId) {
		String returnMessage = null;
		DBManager dbManager = new DBManager();
		try{
			Connection conn = dbManager.getConnection();
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
				dbManager.close(null, pstmt, conn);
			}
		}catch(Exception e){
			e.printStackTrace();
			returnMessage = e.getMessage();
		}
		
		return returnMessage;
	}
	
	public Map<String, String> getBoard(int seq)throws SQLException, ClassNotFoundException{
		DBManager dbManager = new DBManager();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		Map<String, String> board = new HashMap<>();
		try{
			conn = dbManager.getConnection();
			
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
			throw e;
			
		}finally{
			dbManager.close(rs,  pstmt, conn);
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
