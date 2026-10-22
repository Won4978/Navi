package service;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MemberDAO;

public class IdCheckCommand implements Command {

	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String id = request.getParameter("id");

		response.setContentType("application/json; charset=UTF-8");

		PrintWriter out = response.getWriter();

		// 영문 + 숫자 4~20자
		if (id == null || !id.matches("^[A-Za-z0-9]{4,20}$")) {

			out.print("{\"valid\":false," + "\"isDuplicate\":false}");

			return false;
		}

		MemberDAO dao = new MemberDAO();

		boolean isDuplicate = dao.idCheck(id);

		out.print("{\"valid\":true," + "\"isDuplicate\":" + isDuplicate + "}");

		return false;
	}
}