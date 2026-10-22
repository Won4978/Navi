package model;

public class LanguageDTO {
	private int languageId;
	private String languageName;
	private String summary;
	private String description;
	private String features;
	private String usageField;

	public int getLanguageId() {
		return languageId;
	}

	public void setLanguageId(int languageId) {
		this.languageId = languageId;
	}

	public String getLanguageName() {
		return languageName;
	}

	public void setLanguageName(String languageName) {
		this.languageName = languageName;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getFeatures() {
		return features;
	}

	public void setFeatures(String features) {
		this.features = features;
	}

	public String getUsageField() {
		return usageField;
	}

	public void setUsageField(String usageField) {
		this.usageField = usageField;
	}
}
