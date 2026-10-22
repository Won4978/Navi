<%@ page contentType="text/html; charset=UTF-8" %>

<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-about">
            <a class="footer-brand" href="${pageContext.request.contextPath}/home/main">
                DevNavi
            </a>
            <p>
                IT職種とプログラミング言語の関係を、
                初めて学ぶ人にもわかりやすく紹介するキャリア情報サイトです。
            </p>
        </div>

        <div class="footer-column">
            <h2>IT職種</h2>
            <a href="${pageContext.request.contextPath}/career/job?id=1">フロントエンドエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=2">バックエンドエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=3">AIエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=4">データエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=5">インフラ・クラウドエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=6">セキュリティエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=7">ゲームエンジニア</a>
            <a href="${pageContext.request.contextPath}/career/job?id=8">組み込み・制御エンジニア</a>
        </div>

        <div class="footer-column">
            <h2>プログラミング言語</h2>
            <a href="${pageContext.request.contextPath}/career/language?id=1">Java</a>
            <a href="${pageContext.request.contextPath}/career/language?id=2">JavaScript</a>
            <a href="${pageContext.request.contextPath}/career/language?id=3">TypeScript</a>
            <a href="${pageContext.request.contextPath}/career/language?id=4">Python</a>
            <a href="${pageContext.request.contextPath}/career/language?id=5">C</a>
            <a href="${pageContext.request.contextPath}/career/language?id=6">C++</a>
            <a href="${pageContext.request.contextPath}/career/language?id=7">C#</a>
            <a href="${pageContext.request.contextPath}/career/language?id=8">SQL</a>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="footer-bottom-inner">
            <span>© DevNavi</span>
            <div>
                <a href="${pageContext.request.contextPath}/home/main">ホーム</a>
                <a href="${pageContext.request.contextPath}/inquiry/list">お問い合わせ</a>
            </div>
        </div>
    </div>
</footer>
