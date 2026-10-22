package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobDAO;
import model.LanguageDAO;

@WebServlet("/home/main")
public class HomeController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		JobDAO jobDAO = new JobDAO();
		LanguageDAO languageDAO = new LanguageDAO();

		request.setAttribute("jobList", jobDAO.selectAll());
		request.setAttribute("languageList", languageDAO.selectAll());

		forward(request, response, "/index.jsp");
	}

	private void forward(HttpServletRequest request, HttpServletResponse response, String page)
			throws ServletException, IOException {

		request.getRequestDispatcher(page).forward(request, response);
	}
}