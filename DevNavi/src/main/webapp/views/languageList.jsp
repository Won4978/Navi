<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>プログラミング言語から探す | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page">
    <div class="page-title">
        <span class="kicker">LANGUAGES</span>
        <h1>プログラミング言語から探す</h1>
        <p>言語の特徴や活用分野を知り、その言語と関係の深いIT職種を確認できます。</p>
    </div>

    <div class="grid">
        <c:forEach var="lang" items="${languageList}">
            <a class="card language-card"
               href="${pageContext.request.contextPath}/career/language?id=${lang.languageId}">
                <span class="language-mark">${lang.languageName}</span>
                <h3>${lang.languageName}</h3>
                <p>${lang.summary}</p>
                <span class="more">詳しく見る →</span>
            </a>
        </c:forEach>
    </div>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
