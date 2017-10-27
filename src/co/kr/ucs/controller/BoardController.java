package co.kr.ucs.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;

import co.kr.ucs.bean.BoardBean;
import co.kr.ucs.bean.UserBean;
import co.kr.ucs.service.BoardService;

public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
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
		BoardBean params = mapper.readValue(paramString, BoardBean.class);
		
		BoardService boardService = new BoardService();

		Map<String, Object> result = new HashMap<>();
		
		String errorMessage = null;
		
		logger.info("[BoardController]접속 URI : {}", uri);
		logger.info("[BoardController]Parameter : {}", params);
		
		// 게시판 목록 조회
		if(uri.indexOf("/board/boardList") > -1) {
			try {
				
				result.put("boardList" , boardService.getBoardList(params));
				result.put("totalCount", boardService.getTotalCount());
				
			}catch(Exception e) {
				logger.error("{}", e);
				errorMessage = "게시판목록 조회 처리 오류 발생 : " + e.getMessage();
			}
			
		// 게시판 조회
		} else if(uri.indexOf("/board/boardRead") > -1) {
			try {
				result.put("board", boardService.getBoard(params));
			} catch (SQLException e) {
				e.printStackTrace();
				errorMessage = "게시판 조회 처리 오류 발생 : " + e.getMessage();
			}
			
		// 글쓰기
		} else if(uri.indexOf("/board/boardWrite") > -1) {
			String userId   = ((UserBean)request.getSession().getAttribute("SESSION_USER")).getUserId();
			params.setRegId(userId);
			params.setModId(userId);

			try {
				boardService.saveBoard(params);
			} catch (SQLException e) {
				logger.error("{}", e);
				errorMessage = "게시판 글쓰기 저장 처리 오류 발생 : " + e.getMessage();
			}
		} else {
			errorMessage = "잘못된 요청입니다.";
			
		}
		
		if(errorMessage != null) {
			result.put("error", errorMessage);
		}
		
		response.setContentType("text/html;charset=UTF-8");
		response.getOutputStream().write(mapper.writeValueAsBytes(result));
	}

}
