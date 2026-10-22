package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DB;

public class InquiryDAO {

    public int insert(InquiryDTO dto) {
        String sql = "insert into inquiry "
                + "(inquiry_id, member_id, title, content) "
                + "values (seq_inquiry.nextval, ?, ?, ?)";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dto.getMemberId());
            ps.setString(2, dto.getTitle());
            ps.setString(3, dto.getContent());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ArrayList<InquiryDTO> selectList(String memberId, boolean admin) {
        ArrayList<InquiryDTO> list = new ArrayList<>();
        String sql = "select i.inquiry_id, i.member_id, m.nickname, i.title, i.content, i.answer, "
                + "i.status, to_char(i.reg_date, 'YYYY-MM-DD HH24:MI') reg_date, "
                + "to_char(i.answer_date, 'YYYY-MM-DD HH24:MI') answer_date "
                + "from inquiry i join member m on i.member_id=m.id ";

        if (!admin) {
            sql += "where i.member_id=? ";
        }
        sql += "order by i.inquiry_id desc";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql)) {

            if (!admin) {
                ps.setString(1, memberId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(toDTO(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public InquiryDTO selectOne(int inquiryId) {
        String sql = "select i.inquiry_id, i.member_id, m.nickname, i.title, i.content, i.answer, "
                + "i.status, to_char(i.reg_date, 'YYYY-MM-DD HH24:MI') reg_date, "
                + "to_char(i.answer_date, 'YYYY-MM-DD HH24:MI') answer_date "
                + "from inquiry i join member m on i.member_id=m.id where i.inquiry_id=?";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, inquiryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return toDTO(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int markRead(int inquiryId) {
        String sql = "update inquiry set admin_read='Y' where inquiry_id=?";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int answer(int inquiryId, String answer) {
        String sql = "update inquiry set answer=?, status='ANSWERED', answer_date=sysdate "
                + "where inquiry_id=?";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, answer);
            ps.setInt(2, inquiryId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int delete(int inquiryId) {
        String sql = "delete from inquiry where inquiry_id=?";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, inquiryId);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    private InquiryDTO toDTO(ResultSet rs) throws Exception {
        InquiryDTO dto = new InquiryDTO();
        dto.setInquiryId(rs.getInt("inquiry_id"));
        dto.setMemberId(rs.getString("member_id"));
        dto.setNickname(rs.getString("nickname"));
        dto.setTitle(rs.getString("title"));
        dto.setContent(rs.getString("content"));
        dto.setAnswer(rs.getString("answer"));
        dto.setStatus(rs.getString("status"));
        dto.setRegDate(rs.getString("reg_date"));
        dto.setAnswerDate(rs.getString("answer_date"));
        return dto;
    }
}
