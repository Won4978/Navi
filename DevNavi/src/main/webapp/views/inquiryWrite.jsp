<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>お問い合わせを送る | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page form-page">
    <a class="back" href="${pageContext.request.contextPath}/inquiry/list">
        ← お問い合わせ一覧へ
    </a>

    <div class="page-title">
        <span class="kicker">CONTACT</span>
        <h1>管理者に問い合わせる</h1>
        <p>学習方法や職種選びなど、記事に限定されない質問はこちらから送信できます。</p>
    </div>

    <c:if test="${not empty formError}">
        <p class="form-error">${formError}</p>
    </c:if>

    <form class="editor-form" action="${pageContext.request.contextPath}/inquiry/write" method="post">
        <label>
            <span>件名</span>
            <input type="text" name="title" maxlength="200" required>
        </label>

        <label>
            <span>お問い合わせ内容</span>
            <textarea name="content" rows="10" maxlength="3000" required></textarea>
        </label>

        <div class="form-actions">
            <a class="btn" href="${pageContext.request.contextPath}/inquiry/list">キャンセル</a>
            <button class="btn primary" type="submit">送信する</button>
        </div>
    </form>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
