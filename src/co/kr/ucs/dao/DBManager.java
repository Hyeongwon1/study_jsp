package co.kr.ucs.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBManager {
	private final String url = "jdbc:oracle:thin:@220.76.203.39:1521:UCS";
	private final String id  = "UCS_STUDY";
	private final String pw  = "qazxsw";
	
	public Connection getConnection()throws SQLException, ClassNotFoundException{
		Connection conn = null;
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn=DriverManager.getConnection(url,id,pw);
		
		System.out.println("DB 연결성공");
		
		return conn;
	}
	
	public void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		if(rs != null) try{rs.close();}catch(Exception ex){}
		if(pstmt != null) try{pstmt.close();}catch(Exception ex){}
		if(conn  != null) try{conn.close(); }catch(Exception ex){}
	}

}
