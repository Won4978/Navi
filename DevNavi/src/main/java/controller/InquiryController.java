package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InquiryDAO;
import model.InquiryDTO;
import model.MemberDTO;

@WebServlet("/inquiry/*")
public class InquiryController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		MemberDTO loginMember = requireLogin(request, response);

		if (loginMember == null) {
			return;
		}

		String path = request.getPathInfo();

		if (path == null) {
			path = "/list";
		}

		InquiryDAO inquiryDAO = new InquiryDAO();
		boolean isAdmin = "ADMIN".equals(loginMember.getRole());

		switch (path) {

		case "/list":

			request.setAttribute("inquiryList", inquiryDAO.selectList(loginMember.getId(), isAdmin));

			forward(request, response, "/views/inquiryList.jsp");
			break;

		case "/write":

			forward(request, response, "/views/inquiryWrite.jsp");
			break;

		case "/view":

			int inquiryId = parseInt(request.getParameter("id"));

			InquiryDTO inquiry = inquiryDAO.selectOne(inquiryId);

			if (inquiry == null) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
				return;
			}

			if (!isAdmin && !loginMember.getId().equals(inquiry.getMemberId())) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN);
				return;
			}

			if (isAdmin) {
				inquiryDAO.markRead(inquiryId);
			}

			request.setAttribute("inquiry", inquiry);

			forward(request, response, "/views/inquiryView.jsp");
			break;

		default:

			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		MemberDTO loginMember = requireLogin(request, response);

		if (loginMember == null) {
			return;
		}

		String path = request.getPathInfo();

		if (path == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		InquiryDAO inquiryDAO = new InquiryDAO();

		switch (path) {

		case "/write":

			String title = request.getParameter("title");
			String content = request.getParameter("content");

			if (isBlank(title) || isBlank(content)) {

				request.setAttribute("formError", "件名とお問い合わせ内容を入力してください。");

				forward(request, response, "/views/inquiryWrite.jsp");
				return;
			}

			InquiryDTO inquiry = new InquiryDTO();

			inquiry.setMemberId(loginMember.getId());
			inquiry.setTitle(title.trim());
			inquiry.setContent(content.trim());

			inquiryDAO.insert(inquiry);

			response.sendRedirect(request.getContextPath() + "/inquiry/list");

			break;

		case "/answer":

			if (!"ADMIN".equals(loginMember.getRole())) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN);
				return;
			}

			int inquiryId = parseInt(request.getParameter("inquiryId"));

			String answer = request.getParameter("answer");

			if (inquiryId < 1 || isBlank(answer)) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST);
				return;
			}

			inquiryDAO.answer(inquiryId, answer.trim());

			response.sendRedirect(request.getContextPath() + "/inquiry/view?id=" + inquiryId);

			break;
			
		case "/delete":

		    if (!"ADMIN".equals(loginMember.getRole())) {
		        response.sendError(HttpServletResponse.SC_FORBIDDEN);
		        return;
		    }

		    int deleteInquiryId = parseInt(request.getParameter("inquiryId"));

		    if (deleteInquiryId < 1) {
		        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		        return;
		    }

		    int result = inquiryDAO.delete(deleteInquiryId);

		    if (result == 0) {
		        response.sendError(HttpServletResponse.SC_NOT_FOUND);
		        return;
		    }

		    response.sendRedirect(request.getContextPath() + "/inquiry/list");

		    break;

		default:

			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			break;
		}
	}

	private MemberDTO requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {

		HttpSession session = request.getSession(false);

		MemberDTO loginMember = session == null ? null : (MemberDTO) session.getAttribute("loginMember");

		if (loginMember == null) {

			response.sendRedirect(request.getContextPath() + "/member/login");

			return null;
		}

		return loginMember;
	}

	private void forward(HttpServletRequest request, HttpServletResponse response, String page)
			throws ServletException, IOException {

		request.getRequestDispatcher(page).forward(request, response);
	}

	private boolean isBlank(String value) {

		return value == null || value.trim().isEmpty();
	}

	private int parseInt(String value) {

		try {
			return Integer.parseInt(value);

		} catch (Exception e) {
			return -1;
		}
	}
}