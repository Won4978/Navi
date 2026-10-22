package service;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.JobDAO;
import model.JobDTO;

public class JobListCommand implements Command {
	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		JobDAO dao = new JobDAO();
		ArrayList<JobDTO> list = dao.selectAll();
		request.setAttribute("jobList", list);
		return true;
	}
}
