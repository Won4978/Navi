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
import model.InquiryDAO;
import model.MemberDTO;
import model.NotificationDAO;

@WebServlet("/notification/*")
public class NotificationController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        MemberDTO loginMember = requireAdmin(request, response);
        if (loginMember == null) {
            return;
        }

        String path = request.getPathInfo();
        if (path == null) {
            path = "/list";
        }

        switch (path) {
        case "/list":
            NotificationDAO notificationDAO = new NotificationDAO();
            request.setAttribute("notificationList", notificationDAO.selectUnread());
            request.getRequestDispatcher("/views/notificationList.jsp").forward(request, response);
            break;

        case "/open":
            openNotification(request, response);
            break;

        default:
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            break;
        }
    }

    private void openNotification(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        int id = parseInt(request.getParameter("id"));

        if ("COMMENT".equals(type)) {
            CommentDAO commentDAO = new CommentDAO();
            CommentDTO comment = commentDAO.selectOne(id);
            if (comment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            commentDAO.markRead(id);
            String page = "JOB".equals(comment.getTargetType()) ? "/career/job?id=" : "/career/language?id=";
            response.sendRedirect(request.getContextPath() + page + comment.getTargetId() + "#comment-" + id);
            return;
        }

        if ("INQUIRY".equals(type)) {
            InquiryDAO inquiryDAO = new InquiryDAO();
            if (inquiryDAO.selectOne(id) == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            inquiryDAO.markRead(id);
            response.sendRedirect(request.getContextPath() + "/inquiry/view?id=" + id);
            return;
        }

        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }

    private MemberDTO requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        MemberDTO loginMember = session == null ? null : (MemberDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            response.sendRedirect(request.getContextPath() + "/member/login");
            return null;
        }
        if (!"ADMIN".equals(loginMember.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return loginMember;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }
}
