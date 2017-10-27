package co.kr.ucs.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import co.kr.ucs.bean.UserBean;
import co.kr.ucs.service.SignService;

public class SignController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public SignController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uri = request.getRequestURI();
		
		BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
        String paramString = "";
        if(br != null){
        	paramString = br.readLine();
        }
		
		ObjectMapper mapper = new ObjectMapper();
		UserBean params = mapper.readValue(paramString, UserBean.class);
				
		SignService service = new SignService();
		
		String errorMessage = null;
		
		System.out.println("[SignController]접속 URI : " + uri);
		System.out.println("[SignController]Parameter : " + params);
		
		// 로그인
		if(uri.indexOf("/sign/signin") > -1) {
			try {
				UserBean userBean = service.getUser(params);
				
				if(userBean == null) {
					errorMessage = "아이디 또는 비밀번호를 확인하세요.";
				} else {
					HttpSession session = request.getSession(true);
					session.setAttribute("SESSION_USER", userBean);
				}
				
			}catch(Exception e) {
				errorMessage = "로그인 처리 오류 발생 : " + e.getMessage();
			}
		
		// 회원가입
		} else if(uri.indexOf("/sign/signup") > -1) {
			try {
				service.signUp(params);
			} catch (Exception e) {
				errorMessage = "회원가입 처리 오류 발생 : " + e.getMessage();
			}
		} else {
			errorMessage = "잘못된 요청입니다.";
			
		}
		
		Map<String, String> result = new HashMap<>();
		if(errorMessage != null) {
			result.put("error", errorMessage);
		}
		
		response.setContentType("text/html;charset=UTF-8");
		response.getOutputStream().write(mapper.writeValueAsBytes(result));
	}
}
