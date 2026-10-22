package model;

import java.sql.*;
import java.util.ArrayList;
import util.DB;

public class LanguageDAO {
	public ArrayList<LanguageDTO> selectAll() {
		ArrayList<LanguageDTO> list = new ArrayList<>();
		String sql = "select language_id, language_name, summary, description, features, usage_field from programming_language order by language_id";
		try (Connection con = DB.getInstance();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next())
				list.add(toDTO(rs));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public LanguageDTO selectOne(int id) {
		String sql = "select language_id, language_name, summary, description, features, usage_field from programming_language where language_id=?";
		try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return toDTO(rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<JobDTO> selectJobs(int id) {
		ArrayList<JobDTO> list = new ArrayList<>();
		String sql = "select j.job_id,j.job_name,j.summary,j.description,j.main_tasks,j.recommended_for from job_language jl join job j on jl.job_id=j.job_id where jl.language_id=? order by j.job_id";
		try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					JobDTO d = new JobDTO();
					d.setJobId(rs.getInt("job_id"));
					d.setJobName(rs.getString("job_name"));
					d.setSummary(rs.getString("summary"));
					d.setDescription(rs.getString("description"));
					d.setMainTasks(rs.getString("main_tasks"));
					d.setRecommendedFor(rs.getString("recommended_for"));
					list.add(d);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int update(LanguageDTO language) {
		String sql = "update programming_language "
				+ "set summary=?, description=?, features=?, usage_field=? "
				+ "where language_id=?";

		try (Connection con = DB.getInstance();
				PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, language.getSummary());
			ps.setString(2, language.getDescription());
			ps.setString(3, language.getFeatures());
			ps.setString(4, language.getUsageField());
			ps.setInt(5, language.getLanguageId());
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	private LanguageDTO toDTO(ResultSet rs) throws SQLException {
		LanguageDTO d = new LanguageDTO();
		d.setLanguageId(rs.getInt("language_id"));
		d.setLanguageName(rs.getString("language_name"));
		d.setSummary(rs.getString("summary"));
		d.setDescription(rs.getString("description"));
		d.setFeatures(rs.getString("features"));
		d.setUsageField(rs.getString("usage_field"));
		return d;
	}
}
