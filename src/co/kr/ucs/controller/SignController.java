package co.kr.ucs.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
		
		SignService service = new SignService();

		String userId = request.getParameter("userId");
		String userPw = request.getParameter("userPw");
		
		String view = null;
		String errorMessage = null;
		
		System.out.println("[SignController]접속 URI : " + uri);
		
		// 로그인
		if(uri.indexOf("/sign/signin") > -1) {
			view = request.getContextPath()+"/board/boardList";
			try {
				UserBean userBean = service.getUser(userId, userPw);
				
				if(userBean == null) {
					errorMessage = "아이디 또는 비밀번호를 확인하세요.";
				} else {
					HttpSession session = request.getSession(true);
					session.setAttribute("SESSION_USER", session);
				}
				
			}catch(Exception e) {
				errorMessage = "로그인 처리 오류 발생 : " + e.getMessage();
			}
		
		// 회원가입
		} else if(uri.indexOf("/sign/signup") > -1) {
			view = request.getContextPath()+"/jsp/login/signIn.jsp";
			String userNm = request.getParameter("userNm");
			String email  = request.getParameter("email");
			
			try {
				service.signUp(userId, userNm, userPw, email);
			} catch (Exception e) {
				errorMessage = "회원가입 처리 오류 발생 : " + e.getMessage();
			}
		} else {
			errorMessage = "잘못된 요청입니다.";
			
		}
		
		if(errorMessage != null) {
			response.setContentType("text/html;charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.print("<script>");
			out.print("alert('" + errorMessage + "');");
			out.print("history.back();");
			out.print("</script>");
			out.flush();
			
		} else {
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);
			dispatcher.forward(request, response);
		}
		
	}

}
