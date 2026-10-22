<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ログイン | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="auth-page">
    <section class="auth-card">
        <span class="kicker">MEMBER</span>
        <h1>ログイン</h1>
        <p class="auth-description">
            ログインすると、記事へのコメントや管理者へのお問い合わせができます。
        </p>

        <c:if test="${not empty loginFail}">
            <p class="form-error">${loginFail}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/member/login" method="post">
            <label>
                <span>ユーザーID</span>
                <input type="text" name="id" autocomplete="username" required>
            </label>

            <label>
                <span>パスワード</span>
                <input type="password" name="pwd" autocomplete="current-password" required>
            </label>

            <button class="btn primary auth-submit" type="submit">ログイン</button>
        </form>

        <p class="auth-link">
            アカウントをお持ちでない方は
            <a href="${pageContext.request.contextPath}/member/join">会員登録</a>
        </p>
    </section>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
