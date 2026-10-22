package service;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MemberDAO;
import model.MemberDTO;

public class MemberInsert implements Command {

	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// GET 요청이면 회원가입 화면 표시
		if ("GET".equalsIgnoreCase(request.getMethod())) {
			return true;
		}

		request.setCharacterEncoding("UTF-8");

		String id = request.getParameter("id");
		String pwd = request.getParameter("pwd");
		String nickname = request.getParameter("nickname");

		// ID 검사 : 영문 + 숫자 4~20자
		if (id == null || !id.matches("^[A-Za-z0-9]{4,20}$")) {

			request.setAttribute("formError", "ユーザーIDは半角英数字4～20文字で入力してください。");

			return true;
		}

		// 비밀번호 검사 : 영문과 숫자를 포함한 8~20자
		if (pwd == null || !pwd.matches("^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{8,20}$")) {

			request.setAttribute("formError", "パスワードは半角英字と数字を含む8～20文字で入力してください。");

			return true;
		}

		// 닉네임 검사 : 2~20자
		if (nickname == null || nickname.trim().length() < 2 || nickname.trim().length() > 20) {

			request.setAttribute("formError", "ニックネームは2～20文字で入力してください。");

			return true;
		}

		MemberDAO dao = new MemberDAO();

		// ID 중복 재검사
		if (dao.idCheck(id)) {

			request.setAttribute("formError", "すでに使用されているユーザーIDです。");

			return true;
		}

		// 닉네임 중복 재검사
		if (dao.nicknameCheck(nickname.trim())) {

			request.setAttribute("formError", "すでに使用されているニックネームです。");

			return true;
		}

		// BCrypt 비밀번호 해싱
		String hashedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());

		MemberDTO dto = new MemberDTO();

		dto.setId(id);
		dto.setPwd(hashedPwd);
		dto.setNickname(nickname.trim());

		dao.memberInsert(dto);

		response.sendRedirect(request.getContextPath() + "/member/login");

		return false;
	}
}