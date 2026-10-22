package service;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.LanguageDAO;
import model.LanguageDTO;

public class LanguageListCommand implements Command {
	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		LanguageDAO dao = new LanguageDAO();
		ArrayList<LanguageDTO> list = dao.selectAll();
		request.setAttribute("languageList", list);
		return true;
	}
}
