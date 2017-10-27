package co.kr.ucs.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLTimeoutException;

public class DBConnectionPool {

	private int initConns; // 초기에 Pool 에 생성할 Connection 개수
	private int maxConns;  // Pool 에 생성할 최대 Connection 개수 
	
	private long timeOut = 1000 * 30; // Connection 을 얻을때 대기시간 30 초
	
	private String url; // DB 계정 URL
	private String id;  // DB 계정 ID
	private String pw;  // DB 계정 Password
	
	private int[] connStatus; // Connection Pool의 상태
	private Connection[] connPool; // Connection Pool
	
	/***
	 * ConnectionPool 정보 인자를 갖는 생성자
	 * @param url : DB URL
	 * @param id : DB 계정ID
	 * @param pw : DB 계정 PW
	 * @param initConns : 초기 Connection 개수
	 * @param maxConns : 최대 Connection 개수
	 */
	public DBConnectionPool(String url, String id, String pw, int initConns, int maxConns) {
		this.url = url;
		this.id  = id;
		this.pw  = pw;
		
		this.initConns = initConns;
		this.maxConns  = maxConns;
		
		this.connStatus = new int[maxConns];
		this.connPool   = new Connection[maxConns];
		
		for(int i=0; i<this.initConns; i++) {
			try {
				this.createConnection(i);
			} catch (ClassNotFoundException | SQLException e) {
				e.printStackTrace();
				return;
			}
		}
	}
	
	/***
	 * Connection 생성하여 connPool에 추가하는 메소드
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	private Connection createConnection(int pos) throws ClassNotFoundException, SQLException {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn=DriverManager.getConnection(url,id,pw);
		
		this.connPool[pos] = conn;
		this.connStatus[pos] = 1;
		
		return this.connPool[pos];
	}
	
	/**
	 * 사용하지 않는 Connection을 반환
	 * @return
	 * @throws SQLTimeoutException : timeOut 시간동안 Connection을 반환하지 못할때
	 */
	public synchronized Connection getConnection() throws SQLTimeoutException {
		long currTime = System.currentTimeMillis();
		while((System.currentTimeMillis() - currTime) <= this.timeOut) {
			for(int i=0; i<=this.maxConns; i++) {
				if(this.connStatus[i] == 1) {
					this.connStatus[i] = 2;
					return this.connPool[i];
					
				}else if(this.connStatus[i] == 0) {
					try {
						this.connStatus[i] = 2;
						return createConnection(i);
						
					} catch (ClassNotFoundException | SQLException e) {
						e.printStackTrace();
						System.out.println("새로운 Connection 생성 실패");
					}
				}
			}			
			
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
		throw new SQLTimeoutException("모든 Connection이 사용중입니다.");
	}
	
	/**
	 * Connection을 반환
	 * @param conn
	 */
	public void freeConnection(Connection conn) {
		if(conn != null) {
			for(int i=0; i<=this.maxConns; i++) {
				if(this.connPool[i] == conn) {
					this.connStatus[i] = 1;
					break;
				}
			}
		}
	}
	
	/**
	 * getConnection 시 대기 시간 반환
	 * @return
	 */
	public long getTimeOut() {
		return timeOut;
	}
	
	/**
	 * getConnection 시 대기 시간 설정
	 * @param timeOut
	 */
	public void setTimeOut(long timeOut) {
		this.timeOut = timeOut;
	}
}
