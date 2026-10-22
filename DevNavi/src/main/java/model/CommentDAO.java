package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

import util.DB;

public class CommentDAO {

    public ArrayList<CommentDTO> selectByTarget(String targetType, int targetId) {
        ArrayList<CommentDTO> list = new ArrayList<>();
        String sql = "select c.comment_id, c.member_id, m.nickname, c.target_type, c.target_id, "
                + "c.parent_id, c.content, to_char(c.reg_date, 'YYYY-MM-DD HH24:MI') reg_date "
                + "from content_comment c join member m on c.member_id=m.id "
                + "where c.target_type=? and c.target_id=? "
                + "order by nvl(c.parent_id, c.comment_id), "
                + "case when c.parent_id is null then 0 else 1 end, c.comment_id";

        try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, targetType);
            ps.setInt(2, targetId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommentDTO dto = new CommentDTO();
                    dto.setCommentId(rs.getInt("comment_id"));
                    dto.setMemberId(rs.getString("member_id"));
                    dto.setNickname(rs.getString("nickname"));
                    dto.setTargetType(rs.getString("target_type"));
                    dto.setTargetId(rs.getInt("target_id"));
                    int parentId = rs.getInt("parent_id");
                    dto.setParentId(rs.wasNull() ? null : parentId);
                    dto.setContent(rs.getString("content"));
                    dto.setRegDate(rs.getString("reg_date"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insert(CommentDTO dto) {
        String sql = "insert into content_comment "
                + "(comment_id, member_id, target_type, target_id, parent_id, content, admin_read) "
                + "values (seq_content_comment.nextval, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dto.getMemberId());
            ps.setString(2, dto.getTargetType());
            ps.setInt(3, dto.getTargetId());
            if (dto.getParentId() == null) {
                ps.setNull(4, Types.NUMERIC);
            } else {
                ps.setInt(4, dto.getParentId());
            }
            ps.setString(5, dto.getContent());
            ps.setString(6, dto.getParentId() == null ? "N" : "Y");
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public CommentDTO selectOne(int commentId) {
        String sql = "select comment_id, member_id, target_type, target_id, parent_id, content "
                + "from content_comment where comment_id=?";
        try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CommentDTO dto = new CommentDTO();
                    dto.setCommentId(rs.getInt("comment_id"));
                    dto.setMemberId(rs.getString("member_id"));
                    dto.setTargetType(rs.getString("target_type"));
                    dto.setTargetId(rs.getInt("target_id"));
                    int parentId = rs.getInt("parent_id");
                    dto.setParentId(rs.wasNull() ? null : parentId);
                    dto.setContent(rs.getString("content"));
                    return dto;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int markRead(int commentId) {
        String sql = "update content_comment set admin_read='Y' where comment_id=?";
        try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int delete(int commentId, String memberId, boolean admin) {
        String sql = admin
                ? "delete from content_comment where comment_id=?"
                : "delete from content_comment where comment_id=? and member_id=? and parent_id is null";

        try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            if (!admin) {
                ps.setString(2, memberId);
            }
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
