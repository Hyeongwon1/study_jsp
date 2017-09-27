package co.kr.ucs.bean;

public class UserBean {
	private String userId;
	private String userPw;
	private String email;
	private String userNm;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	@Override
	public String toString() {
		return "UserBean [userId=" + userId + ", userPw=" + userPw + ", email=" + email + ", userNm=" + userNm
				+ ", getUserId()=" + getUserId() + ", getUserPw()=" + getUserPw() + ", getEmail()=" + getEmail()
				+ ", getUserNm()=" + getUserNm() + ", getClass()=" + getClass() + ", hashCode()=" + hashCode()
				+ ", toString()=" + super.toString() + "]";
	}
	
	
}
