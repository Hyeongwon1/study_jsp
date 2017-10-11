package co.kr.ucs.dao;

import java.util.HashMap;
import java.util.Map;

/**
 * DBConnectionPool을 관리하는 객체
 * - 여러 DB 계정을 Pool Name 으로 관리 할 수 있다.
 * @author sdh
 *
 */
public class DBConnectionPoolManager {
	private static String DEFAULT_POOLNAME = "DEFAULT";
	private static Map<String, DBConnectionPool> dbPool = new HashMap<>();
	private static DBConnectionPoolManager instance = new DBConnectionPoolManager();
	/**
	 * DBConnectionPoolManager 객체 반환
	 * @return DBConnectionPoolManager
	 */
	public static DBConnectionPoolManager getInstance() {
		return instance;
	}
	/**
	 * DB Pool 생성
	 * @param url
	 * @param id
	 * @param pw
	 */
	public void setDBPool(String url, String id, String pw) {
		setDBPool(DEFAULT_POOLNAME, url, id, pw, 1, 10);
	}
	/**
	 * DB Pool 생성
	 * @param poolName
	 * @param url
	 * @param id
	 * @param pw
	 */
	public void setDBPool(String poolName, String url, String id, String pw) {
		setDBPool(poolName, url, id, pw, 1, 10);
	}
	/**
	 * DB Pool 생성
	 * @param poolName
	 * @param url
	 * @param id
	 * @param pw
	 * @param initConns
	 */
	public void setDBPool(String poolName, String url, String id, String pw, int initConns) {
		setDBPool(poolName, url, id, pw, initConns, 10);
	}
	/**
	 * DB Pool 생성
	 * @param poolName
	 * @param url
	 * @param id
	 * @param pw
	 * @param initConns
	 * @param maxConns
	 */
	public void setDBPool(String poolName, String url, String id, String pw, int initConns, int maxConns) {
		if(!dbPool.containsKey(poolName)) {
			DBConnectionPool connPool = new DBConnectionPool(url, id, pw, initConns, maxConns);
			dbPool.put(poolName, connPool);
		}
	}
	
	/**
	 * DB Pool 반환 
	 * @return DEFAULT_POLLNAME 의 DBConnectionPool
	 */
	public DBConnectionPool getDBPool() {
		return getDBPool(DEFAULT_POOLNAME);
	}

	/**
	 * DB Pool 반환 
	 * @param poolName
	 * @return
	 */
	public DBConnectionPool getDBPool(String poolName) {
		return dbPool.get(poolName);
	}
	
}
