package co.kr.ucs.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.kr.ucs.bean.SearchBean;
import co.kr.ucs.service.BoardService;

public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public BoardController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uri = request.getRequestURI();
		
		BoardService boardService = new BoardService();

		
		String view = null;
		String errorMessage = null;
		
		System.out.println("[BoardController]접속 URI : " + uri);
		// 게시판 목록 조회
		if(uri.indexOf("/board/boardList") > -1) {
			view = request.getContextPath()+"/jsp/board/boardList.jsp";
			try {
				
				String searchType = request.getParameter("searchType");
				String search     = request.getParameter("search");
				String currPage   = request.getParameter("currPage");
				
				currPage = currPage == null ? "1" : currPage;
				
				SearchBean searchBean = new SearchBean();
				searchBean.setSearchType(searchType);
				searchBean.setSearch(search);
				searchBean.setCurrPage(Integer.parseInt(currPage));
				
				request.setAttribute("boardList" , boardService.getBoardList(searchBean));
				request.setAttribute("totalCount", boardService.getTotalCount());
				request.setAttribute("searchBean", searchBean);
				
				
			}catch(Exception e) {
				e.printStackTrace();
				errorMessage = "게시판목록 조회 처리 오류 발생 : " + e.getMessage();
			}
			
		// 게시판 조회
		} else if(uri.indexOf("/board/boardRead") > -1) {
			view = request.getContextPath()+"/jsp/board/boardRead.jsp";
			int seq = Integer.parseInt(request.getParameter("seq"));
			
			try {
				request.setAttribute("board", boardService.getBoardBean(seq));
			} catch (SQLException e) {
				e.printStackTrace();
				errorMessage = "게시판 조회 처리 오류 발생 : " + e.getMessage();
			}
			
		// 글쓰기
		} else if(uri.indexOf("/board/boardWrite") > -1) {
			String userId   = request.getParameter("userId");
			String title    = request.getParameter("title");
			String contents = request.getParameter("contents");
			try {
				boardService.saveBoard(title, contents, userId);
				
				response.sendRedirect(request.getContextPath()+"/board/boardList");
				return;
			} catch (SQLException e) {
				e.printStackTrace();
				errorMessage = "게시판 글쓰기 저장 처리 오류 발생 : " + e.getMessage();
			}
		} else {
			errorMessage = "잘못된 요청입니다.";
			
		}
		
		if(errorMessage != null) {
			System.out.println("errorMessage : " + errorMessage);
			
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
