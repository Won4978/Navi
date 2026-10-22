package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DB;

public class NotificationDAO {

    public int countUnread() {
        String sql = "select "
                + "(select count(*) from content_comment where parent_id is null and admin_read='N') + "
                + "(select count(*) from inquiry where admin_read='N') as cnt from dual";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ArrayList<NotificationDTO> selectUnread() {
        ArrayList<NotificationDTO> list = new ArrayList<>();
        String sql = "select notification_type, notification_id, nickname, title, reg_date from ("
                + "select 'COMMENT' notification_type, c.comment_id notification_id, m.nickname, "
                + "c.content title, c.reg_date "
                + "from content_comment c join member m on c.member_id=m.id "
                + "where c.parent_id is null and c.admin_read='N' "
                + "union all "
                + "select 'INQUIRY', i.inquiry_id, m.nickname, i.title, i.reg_date "
                + "from inquiry i join member m on i.member_id=m.id where i.admin_read='N'"
                + ") order by reg_date desc";

        try (Connection con = DB.getInstance();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                NotificationDTO dto = new NotificationDTO();
                dto.setType(rs.getString("notification_type"));
                dto.setId(rs.getInt("notification_id"));
                dto.setNickname(rs.getString("nickname"));
                dto.setTitle(rs.getString("title"));
                dto.setRegDate(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm")
                        .format(rs.getTimestamp("reg_date")));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
