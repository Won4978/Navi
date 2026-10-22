<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${inquiry.title}| DevNavi</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

	<jsp:include page="/include/header.jsp" />

	<main class="page inquiry-view">
		<a class="back" href="${pageContext.request.contextPath}/inquiry/list">
			← お問い合わせ一覧へ </a>

		<article class="inquiry-detail-card">
			<div class="inquiry-detail-meta">
				<span><c:out value="${inquiry.nickname}" />さん</span> <span>${inquiry.regDate}</span>
			</div>
			<h1>
				<c:out value="${inquiry.title}" />
			</h1>
			<p>
				<c:out value="${inquiry.content}" />
			</p>
		</article>

		<section class="answer-card">
			<span class="kicker">ANSWER</span>
			<h2>管理者からの回答</h2>

			<c:choose>
				<c:when test="${not empty inquiry.answer}">
					<p>
						<c:out value="${inquiry.answer}" />
					</p>
					<span class="answer-date">${inquiry.answerDate}</span>
				</c:when>
				<c:otherwise>
					<p class="muted">現在、回答を準備しています。</p>
				</c:otherwise>
			</c:choose>

			<c:if test="${sessionScope.loginMember.role eq 'ADMIN' and empty inquiry.answer}">
				<form class="answer-form"
					action="${pageContext.request.contextPath}/inquiry/answer"
					method="post">
					<input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">
					<label for="answer">回答を入力</label>
					<textarea id="answer" name="answer" rows="8" required>${inquiry.answer}</textarea>
					<div class="form-actions">
						<button class="btn primary" type="submit">回答を保存する</button>
					</div>
				</form>

				<form action="${pageContext.request.contextPath}/inquiry/delete"
					method="post" onsubmit="return confirm('このお問い合わせを削除しますか？');">

					<input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">

					<div class="form-actions">
						<button class="btn" type="submit">お問い合わせを削除する</button>
					</div>

				</form>

			</c:if>
		</section>
	</main>

	<jsp:include page="/include/footer.jsp" />

</body>
</html>
