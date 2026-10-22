<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IT職種から探す | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page">
    <div class="page-title">
        <span class="kicker">JOBS</span>
        <h1>IT職種から探す</h1>
        <p>仕事内容や役割を知り、そこから関連するプログラミング言語へ進めます。</p>
    </div>

    <div class="grid">
        <c:forEach var="job" items="${jobList}">
            <a class="card" href="${pageContext.request.contextPath}/career/job?id=${job.jobId}">
                <span class="num">0${job.jobId}</span>
                <h3>${job.jobName}</h3>
                <p>${job.summary}</p>
                <span class="more">詳しく見る →</span>
            </a>
        </c:forEach>
    </div>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
