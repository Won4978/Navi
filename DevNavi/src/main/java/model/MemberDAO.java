package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DB;

public class MemberDAO {

	// =========================================================
	// ID 중복 확인
	// =========================================================

	public boolean idCheck(String id) {

		String sql = "SELECT id FROM member WHERE LOWER(id)=LOWER(?)";
		
		boolean isDuplicate = false;

		try (Connection conn = DB.getInstance(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, id);

			try (ResultSet rs = pstmt.executeQuery()) {

				isDuplicate = rs.next();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return isDuplicate;
	}

	// =========================================================
	// 닉네임 중복 확인
	// =========================================================

	public boolean nicknameCheck(String nickname) {

		String sql = "SELECT nickname FROM member WHERE nickname=?";

		boolean isDuplicate = false;

		try (Connection conn = DB.getInstance(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, nickname);

			try (ResultSet rs = pstmt.executeQuery()) {

				isDuplicate = rs.next();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return isDuplicate;
	}

	// =========================================================
	// 회원가입
	// =========================================================

	public void memberInsert(MemberDTO dto) {

		String sql = "INSERT INTO member(ID, PWD, NICKNAME) " + "VALUES (?, ?, ?)";

		try (Connection conn = DB.getInstance(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPwd());
			pstmt.setString(3, dto.getNickname());

			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// =========================================================
	// 로그인
	// =========================================================

	public MemberDTO login(String id) {

		String sql = "SELECT id, pwd, nickname, role, " + "TO_CHAR(join_date, 'YYYY-MM-DD') AS join_date "
				+ "FROM member " + "WHERE LOWER(id)=LOWER(?)";

		MemberDTO dto = null;

		try (Connection conn = DB.getInstance(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, id);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {

					dto = new MemberDTO();

					dto.setId(rs.getString("id"));
					dto.setPwd(rs.getString("pwd"));
					dto.setNickname(rs.getString("nickname"));
					dto.setRole(rs.getString("role"));
					dto.setJoin_date(rs.getString("join_date"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;
	}
}