package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.MemberDTO;
import model.NotificationDAO;

@WebFilter("/*")
public class AdminNotificationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        String uri = httpRequest.getRequestURI();
        boolean staticResource = uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/");

        if (!staticResource && session != null) {
            MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
            if (loginMember != null && "ADMIN".equals(loginMember.getRole())) {
                NotificationDAO dao = new NotificationDAO();
                request.setAttribute("adminNotificationCount", dao.countUnread());
            }
        }

        chain.doFilter(request, response);
    }
}
