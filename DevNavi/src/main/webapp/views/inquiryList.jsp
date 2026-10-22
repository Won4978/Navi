<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>お問い合わせ | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page inquiry-page">
    <div class="section-head inquiry-head">
        <div>
            <span class="kicker">CONTACT</span>
            <h1>お問い合わせ</h1>
            <p>
                特定の記事に限らない学習方法やITキャリアについて、管理者へ質問できます。
            </p>
        </div>

        <c:if test="${sessionScope.loginMember.role ne 'ADMIN'}">
            <a class="btn primary" href="${pageContext.request.contextPath}/inquiry/write">
                新しく問い合わせる
            </a>
        </c:if>
    </div>

    <div class="inquiry-list">
        <c:choose>
            <c:when test="${empty inquiryList}">
                <div class="empty-message">お問い合わせはまだありません。</div>
            </c:when>

            <c:otherwise>
                <c:forEach var="item" items="${inquiryList}">
                    <a class="inquiry-item"
                       href="${pageContext.request.contextPath}/inquiry/view?id=${item.inquiryId}">
                        <div>
                            <c:if test="${sessionScope.loginMember.role eq 'ADMIN'}">
                                <span class="inquiry-user"><c:out value="${item.nickname}" />さん</span>
                            </c:if>
                            <h2><c:out value="${item.title}" /></h2>
                            <span>${item.regDate}</span>
                        </div>

                        <c:choose>
                            <c:when test="${item.status eq 'ANSWERED'}">
                                <span class="status answered">回答済み</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status waiting">回答待ち</span>
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
