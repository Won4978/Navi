<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="site-header">
    <div class="nav-wrap">
        <a class="brand" href="${pageContext.request.contextPath}/home/main">
            DevNavi
        </a>

        <nav class="main-nav" aria-label="メインナビゲーション">
            <a href="${pageContext.request.contextPath}/home/main">ホーム</a>
            <a href="${pageContext.request.contextPath}/career/jobs">職種から探す</a>
            <a href="${pageContext.request.contextPath}/career/languages">言語から探す</a>
            <a href="${pageContext.request.contextPath}/inquiry/list">お問い合わせ</a>
        </nav>

        <div class="account-nav">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember}">
                    <span class="welcome-name">
                        ${sessionScope.loginMember.nickname}さん
                    </span>

                    <c:if test="${sessionScope.loginMember.role eq 'ADMIN'}">
                        <a class="notification-link" href="${pageContext.request.contextPath}/notification/list"
                           aria-label="管理者通知">
                            🔔
                            <c:if test="${adminNotificationCount gt 0}">
                                <span class="notification-count">${adminNotificationCount}</span>
                            </c:if>
                        </a>
                        <span class="admin-badge">ADMIN</span>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/member/logout">ログアウト</a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/member/login">ログイン</a>
                    <a class="header-join" href="${pageContext.request.contextPath}/member/join">
                        会員登録
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
