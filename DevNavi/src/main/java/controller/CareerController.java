package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CommentDAO;
import model.JobDAO;
import model.JobDTO;
import model.LanguageDAO;
import model.LanguageDTO;
import model.MemberDTO;

@WebServlet("/career/*")
public class CareerController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getPathInfo();

		if (path == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		switch (path) {

		case "/jobs":
			showJobList(request, response);
			break;

		case "/job":
			showJobDetail(request, response);
			break;

		case "/jobEdit":
			showJobEdit(request, response);
			break;

		case "/languages":
			showLanguageList(request, response);
			break;

		case "/language":
			showLanguageDetail(request, response);
			break;

		case "/languageEdit":
			showLanguageEdit(request, response);
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

		if (!requireAdmin(request, response)) {
			return;
		}

		String path = request.getPathInfo();

		if (path == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		switch (path) {

		case "/jobUpdate":
			updateJob(request, response);
			break;

		case "/languageUpdate":
			updateLanguage(request, response);
			break;

		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			break;
		}
	}

	// =========================================================
	// JOB
	// =========================================================

	private void showJobList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		JobDAO jobDAO = new JobDAO();

		request.setAttribute("jobList", jobDAO.selectAll());

		forward(request, response, "/views/jobList.jsp");
	}

	private void showJobDetail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int jobId = parseInt(request.getParameter("id"));

		JobDAO jobDAO = new JobDAO();
		JobDTO job = jobDAO.selectOne(jobId);

		if (job == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		CommentDAO commentDAO = new CommentDAO();

		request.setAttribute("job", job);

		request.setAttribute("languageList", jobDAO.selectLanguages(jobId));

		request.setAttribute("commentList", commentDAO.selectByTarget("JOB", jobId));

		request.setAttribute("newline", "\n");

		forward(request, response, "/views/jobDetail.jsp");
	}

	private void showJobEdit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!requireAdmin(request, response)) {
			return;
		}

		int jobId = parseInt(request.getParameter("id"));

		JobDAO jobDAO = new JobDAO();
		JobDTO job = jobDAO.selectOne(jobId);

		if (job == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		request.setAttribute("job", job);

		forward(request, response, "/views/jobEdit.jsp");
	}

	private void updateJob(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int jobId = parseInt(request.getParameter("jobId"));

		JobDTO job = new JobDTO();

		job.setJobId(jobId);
		job.setSummary(request.getParameter("summary"));
		job.setDescription(request.getParameter("description"));
		job.setMainTasks(request.getParameter("mainTasks"));
		job.setRecommendedFor(request.getParameter("recommendedFor"));

		JobDAO jobDAO = new JobDAO();

		int result = jobDAO.update(job);

		if (result > 0) {

			response.sendRedirect(request.getContextPath() + "/career/job?id=" + jobId);

		} else {

			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}

	// =========================================================
	// LANGUAGE
	// =========================================================

	private void showLanguageList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		LanguageDAO languageDAO = new LanguageDAO();

		request.setAttribute("languageList", languageDAO.selectAll());

		forward(request, response, "/views/languageList.jsp");
	}

	private void showLanguageDetail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int languageId = parseInt(request.getParameter("id"));

		LanguageDAO languageDAO = new LanguageDAO();

		LanguageDTO language = languageDAO.selectOne(languageId);

		if (language == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		CommentDAO commentDAO = new CommentDAO();

		request.setAttribute("language", language);

		request.setAttribute("jobList", languageDAO.selectJobs(languageId));

		request.setAttribute("commentList", commentDAO.selectByTarget("LANGUAGE", languageId));

		request.setAttribute("newline", "\n");

		forward(request, response, "/views/languageDetail.jsp");
	}

	private void showLanguageEdit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!requireAdmin(request, response)) {
			return;
		}

		int languageId = parseInt(request.getParameter("id"));

		LanguageDAO languageDAO = new LanguageDAO();

		LanguageDTO language = languageDAO.selectOne(languageId);

		if (language == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		request.setAttribute("language", language);

		forward(request, response, "/views/languageEdit.jsp");
	}

	private void updateLanguage(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int languageId = parseInt(request.getParameter("languageId"));

		LanguageDTO language = new LanguageDTO();

		language.setLanguageId(languageId);
		language.setSummary(request.getParameter("summary"));
		language.setDescription(request.getParameter("description"));
		language.setFeatures(request.getParameter("features"));
		language.setUsageField(request.getParameter("usageField"));

		LanguageDAO languageDAO = new LanguageDAO();

		int result = languageDAO.update(language);

		if (result > 0) {

			response.sendRedirect(request.getContextPath() + "/career/language?id=" + languageId);

		} else {

			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}

	// =========================================================
	// COMMON
	// =========================================================

	private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {

		HttpSession session = request.getSession(false);

		MemberDTO loginMember = session == null ? null : (MemberDTO) session.getAttribute("loginMember");

		if (loginMember == null) {

			response.sendRedirect(request.getContextPath() + "/member/login");

			return false;
		}

		if (!"ADMIN".equals(loginMember.getRole())) {

			response.sendError(HttpServletResponse.SC_FORBIDDEN);

			return false;
		}

		return true;
	}

	private int parseInt(String value) {

		try {
			return Integer.parseInt(value);

		} catch (Exception e) {
			return -1;
		}
	}

	private void forward(HttpServletRequest request, HttpServletResponse response, String page)
			throws ServletException, IOException {

		request.getRequestDispatcher(page).forward(request, response);
	}
}