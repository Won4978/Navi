<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${language.languageName}を編集 | DevNavi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

<jsp:include page="/include/header.jsp" />

<main class="page editor-page">
    <a class="back" href="${pageContext.request.contextPath}/career/language?id=${language.languageId}">
        ← 詳細ページへ戻る
    </a>

    <div class="page-title">
        <span class="kicker">ADMIN EDITOR</span>
        <h1>${language.languageName}を編集</h1>
        <p>プログラミング言語の説明・特徴・活用分野を編集します。</p>
    </div>

    <form class="editor-form"
          action="${pageContext.request.contextPath}/career/languageUpdate"
          method="post">

        <input type="hidden" name="languageId" value="${language.languageId}">

        <label>
            <span>概要</span>
            <textarea name="summary" rows="4" required>${language.summary}</textarea>
        </label>

        <label>
            <span>言語について</span>
            <textarea name="description" rows="10">${language.description}</textarea>
        </label>

        <label>
            <span>特徴</span>
            <small>1項目ごとに改行すると、詳細ページでカードとして表示されます。</small>
            <textarea name="features" rows="10">${language.features}</textarea>
        </label>

        <label>
            <span>主な活用分野</span>
            <textarea name="usageField" rows="8">${language.usageField}</textarea>
        </label>

        <div class="form-actions">
            <a class="btn" href="${pageContext.request.contextPath}/career/language?id=${language.languageId}">
                キャンセル
            </a>
            <button class="btn primary" type="submit">保存する</button>
        </div>
    </form>
</main>

<jsp:include page="/include/footer.jsp" />

</body>
</html>
