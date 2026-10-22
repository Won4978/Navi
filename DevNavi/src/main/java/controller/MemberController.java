package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.Command;
import service.IdCheckCommand;
import service.LoginCommand;
import service.LogoutCommand;
import service.MemberInsert;
import service.NicknameCheckCommand;

@WebServlet("/member/*")
public class MemberController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doAction(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doAction(request, response);
	}

	private void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getPathInfo();

		Command command;
		String page;

		if (path == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		switch (path) {

		case "/join":
			command = new MemberInsert();
			page = "/mem/join.jsp";
			break;

		case "/idCheck":
			command = new IdCheckCommand();
			page = null;
			break;
		
		case "/nicknameCheck":
		    command = new NicknameCheckCommand();
		    page = null;
		    break;

		case "/login":
			command = new LoginCommand();
			page = "/mem/login.jsp";
			break;

		case "/logout":
			command = new LogoutCommand();
			page = null;
			break;

		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		boolean needForward = command.doCommand(request, response);

		if (needForward && page != null) {
			forward(request, response, page);
		}
	}

	private void forward(HttpServletRequest request, HttpServletResponse response, String page)
			throws ServletException, IOException {

		request.getRequestDispatcher(page).forward(request, response);
	}
}