package model;

public class NotificationDTO {
    private String type;
    private int id;
    private String nickname;
    private String title;
    private String regDate;

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }
}
