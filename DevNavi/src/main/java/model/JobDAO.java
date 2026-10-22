package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import util.DB;

public class JobDAO {
	public ArrayList<JobDTO> selectAll() {
		ArrayList<JobDTO> list = new ArrayList<>();
		String sql = "select job_id, job_name, summary, description, main_tasks, recommended_for from job order by job_id";
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

	public JobDTO selectOne(int jobId) {
		String sql = "select job_id, job_name, summary, description, main_tasks, recommended_for from job where job_id=?";
		try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, jobId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return toDTO(rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<LanguageDTO> selectLanguages(int jobId) {
		ArrayList<LanguageDTO> list = new ArrayList<>();
		String sql = "select p.language_id, p.language_name, p.summary, p.description, p.features, p.usage_field "
				+ "from job_language jl join programming_language p on jl.language_id=p.language_id "
				+ "where jl.job_id=? order by p.language_id";
		try (Connection con = DB.getInstance(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, jobId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					LanguageDTO d = new LanguageDTO();
					d.setLanguageId(rs.getInt("language_id"));
					d.setLanguageName(rs.getString("language_name"));
					d.setSummary(rs.getString("summary"));
					d.setDescription(rs.getString("description"));
					d.setFeatures(rs.getString("features"));
					d.setUsageField(rs.getString("usage_field"));
					list.add(d);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int update(JobDTO job) {

	    String sql = "update job "
	            + "set summary=?, description=?, main_tasks=?, recommended_for=? "
	            + "where job_id=?";

	    try (Connection con = DB.getInstance();
	            PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, job.getSummary());
	        ps.setString(2, job.getDescription());
	        ps.setString(3, job.getMainTasks());
	        ps.setString(4, job.getRecommendedFor());
	        ps.setInt(5, job.getJobId());

	        return ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}

	private JobDTO toDTO(ResultSet rs) throws SQLException {
		JobDTO d = new JobDTO();
		d.setJobId(rs.getInt("job_id"));
		d.setJobName(rs.getString("job_name"));
		d.setSummary(rs.getString("summary"));
		d.setDescription(rs.getString("description"));
		d.setMainTasks(rs.getString("main_tasks"));
		d.setRecommendedFor(rs.getString("recommended_for"));
		return d;
	}
}
