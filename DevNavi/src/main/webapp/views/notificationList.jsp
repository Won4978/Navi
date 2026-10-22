<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>管理者通知 | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page inquiry-page">
    <div class="section-head inquiry-head">
        <div>
            <span class="kicker">NOTIFICATIONS</span>
            <h1>管理者通知</h1>
            <p>新しいコメント・質問とお問い合わせを確認できます。</p>
        </div>
    </div>

    <div class="notification-list">
        <c:choose>
            <c:when test="${empty notificationList}">
                <div class="empty-message">未確認の通知はありません。</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${notificationList}">
                    <a class="notification-item"
                       href="${pageContext.request.contextPath}/notification/open?type=${item.type}&id=${item.id}">
                        <div>
                            <span class="notification-type">
                                ${item.type eq 'COMMENT' ? 'コメント・質問' : 'お問い合わせ'}
                            </span>
                            <strong><c:out value="${item.nickname}" />さん</strong>
                            <p><c:out value="${item.title}" /></p>
                            <span>${item.regDate}</span>
                        </div>
                        <em>確認する →</em>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/include/footer.jsp" />
</body>
</html>
