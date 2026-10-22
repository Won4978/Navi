<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${job.jobName}を編集 | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page editor-page">
    <a class="back" href="${pageContext.request.contextPath}/career/job?id=${job.jobId}">
        ← 詳細ページへ戻る
    </a>

    <div class="page-title">
        <span class="kicker">ADMIN EDITOR</span>
        <h1>${job.jobName}を編集</h1>
        <p>職種情報の本文を編集します。改行は詳細ページにも反映されます。</p>
    </div>

    <form class="editor-form"
          action="${pageContext.request.contextPath}/career/jobUpdate"
          method="post">

        <input type="hidden" name="jobId" value="${job.jobId}">

        <label>
            <span>概要</span>
            <textarea name="summary" rows="4" required>${job.summary}</textarea>
        </label>

        <label>
            <span>職種について</span>
            <textarea name="description" rows="10">${job.description}</textarea>
        </label>

        <label>
            <span>主な仕事内容</span>
            <small>1項目ごとに改行すると、詳細ページでカードとして表示されます。</small>
            <textarea name="mainTasks" rows="10">${job.mainTasks}</textarea>
        </label>

        <label>
            <span>こんな人におすすめ</span>
            <small>1項目ごとに改行してください。</small>
            <textarea name="recommendedFor" rows="9">${job.recommendedFor}</textarea>
        </label>

        <div class="form-actions">
            <a class="btn" href="${pageContext.request.contextPath}/career/job?id=${job.jobId}">
                キャンセル
            </a>
            <button class="btn primary" type="submit">保存する</button>
        </div>
    </form>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
