package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CommentDAO;
import model.CommentDTO;
import model.MemberDTO;

@WebServlet("/comment/*")
public class CommentController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		MemberDTO loginMember = getLoginMember(request);

		if (loginMember == null) {
			response.sendRedirect(request.getContextPath() + "/member/login");
			return;
		}

		String path = request.getPathInfo();

		if (path == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		switch (path) {

		case "/write":
			write(request, response, loginMember);
			break;

		case "/reply":
			reply(request, response, loginMember);
			break;

		case "/delete":
			delete(request, response, loginMember);
			break;

		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			break;
		}
	}

	private void write(HttpServletRequest request, HttpServletResponse response, MemberDTO loginMember)
			throws IOException {

		String targetType = normalizeTargetType(request.getParameter("targetType"));
		int targetId = parseInt(request.getParameter("targetId"));
		String content = request.getParameter("content");

		if (targetType == null || targetId < 1 || content == null || content.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		CommentDTO comment = new CommentDTO();

		comment.setMemberId(loginMember.getId());
		comment.setTargetType(targetType);
		comment.setTargetId(targetId);
		comment.setContent(content.trim());

		CommentDAO commentDAO = new CommentDAO();
		commentDAO.insert(comment);

		redirectToTarget(request, response, targetType, targetId);
	}

	private void reply(HttpServletRequest request, HttpServletResponse response, MemberDTO loginMember)
			throws IOException {

		if (!"ADMIN".equals(loginMember.getRole())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		int parentId = parseInt(request.getParameter("parentId"));
		String content = request.getParameter("content");
		CommentDAO commentDAO = new CommentDAO();
		CommentDTO parent = commentDAO.selectOne(parentId);

		if (parent == null || parent.getParentId() != null || content == null || content.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		CommentDTO reply = new CommentDTO();
		reply.setMemberId(loginMember.getId());
		reply.setTargetType(parent.getTargetType());
		reply.setTargetId(parent.getTargetId());
		reply.setParentId(parentId);
		reply.setContent(content.trim());

		commentDAO.insert(reply);
		commentDAO.markRead(parentId);

		redirectToTarget(request, response, parent.getTargetType(), parent.getTargetId());
	}

	private void delete(HttpServletRequest request, HttpServletResponse response, MemberDTO loginMember)
			throws IOException {

		int commentId = parseInt(request.getParameter("commentId"));
		String targetType = normalizeTargetType(request.getParameter("targetType"));
		int targetId = parseInt(request.getParameter("targetId"));

		boolean isAdmin = "ADMIN".equals(loginMember.getRole());

		CommentDAO commentDAO = new CommentDAO();
		commentDAO.delete(commentId, loginMember.getId(), isAdmin);

		redirectToTarget(request, response, targetType, targetId);
	}

	private void redirectToTarget(HttpServletRequest request, HttpServletResponse response, String targetType,
			int targetId) throws IOException {

		String page;

		if ("JOB".equals(targetType)) {
			page = "/career/job?id=";
		} else {
			page = "/career/language?id=";
		}

		response.sendRedirect(request.getContextPath() + page + targetId + "#comments");
	}

	private MemberDTO getLoginMember(HttpServletRequest request) {

		HttpSession session = request.getSession(false);

		if (session == null) {
			return null;
		}

		return (MemberDTO) session.getAttribute("loginMember");
	}

	private String normalizeTargetType(String value) {

		if ("JOB".equalsIgnoreCase(value)) {
			return "JOB";
		}

		if ("LANGUAGE".equalsIgnoreCase(value)) {
			return "LANGUAGE";
		}

		return null;
	}

	private int parseInt(String value) {

		try {
			return Integer.parseInt(value);

		} catch (Exception e) {
			return -1;
		}
	}
}