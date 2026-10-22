package service;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MemberDAO;

public class NicknameCheckCommand implements Command {

    @Override
    public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nickname = request.getParameter("nickname");

        response.setContentType("application/json; charset=UTF-8");

        PrintWriter out = response.getWriter();

        if (nickname == null
                || nickname.trim().length() < 2
                || nickname.trim().length() > 20) {

            out.print(
                    "{\"valid\":false,"
                    + "\"isDuplicate\":false}"
            );

            return false;
        }

        MemberDAO dao = new MemberDAO();

        boolean isDuplicate =
                dao.nicknameCheck(nickname.trim());

        out.print(
                "{\"valid\":true,"
                + "\"isDuplicate\":" + isDuplicate + "}"
        );

        return false;
    }
}