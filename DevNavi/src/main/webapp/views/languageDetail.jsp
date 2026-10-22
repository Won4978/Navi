<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${language.languageName}| DevNavi</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/devnavi.css">
</head>
<body>

	<jsp:include page="/include/header.jsp" />

	<main class="page detail-page">
		<a class="back"
			href="${pageContext.request.contextPath}/career/languages"> ←
			言語一覧へ </a>

		<article>
			<header class="detail-hero language-hero">
				<div>
					<span class="kicker">LANGUAGE GUIDE</span>
					<h1>${language.languageName}</h1>
					<p class="lead">${language.summary}</p>
				</div>

				<c:if test="${sessionScope.loginMember.role eq 'ADMIN'}">
					<a class="btn admin-edit"
						href="${pageContext.request.contextPath}/career/languageEdit?id=${language.languageId}">
						編集する </a>
				</c:if>
			</header>

			<c:if test="${not empty language.description}">
				<section class="content-section">
					<div class="content-section-title">
						<span>01</span>
						<div>
							<small>ABOUT</small>
							<h2>${language.languageName}とは？</h2>
						</div>
					</div>
					<div class="prose-card">
						<p>${language.description}</p>
					</div>
				</section>
			</c:if>

			<c:if test="${not empty language.features}">
				<section class="content-section">
					<div class="content-section-title">
						<span>02</span>
						<div>
							<small>FEATURES</small>
							<h2>特徴</h2>
						</div>
					</div>
					<div class="point-grid">
						<c:forEach var="feature"
							items="${fn:split(language.features, newline)}">
							<c:if test="${not empty fn:trim(feature)}">
								<div class="point-card">
									<span class="point-dot"></span>
									<p>${fn:replace(feature, '・', '')}</p>
								</div>
							</c:if>
						</c:forEach>
					</div>
				</section>
			</c:if>

			<c:if test="${not empty language.usageField}">
				<section class="content-section">
					<div class="content-section-title">
						<span>03</span>
						<div>
							<small>USAGE</small>
							<h2>主な活用分野</h2>
						</div>
					</div>
					<div class="prose-card accent-card">
						<p>${language.usageField}</p>
					</div>
				</section>
			</c:if>

			<section class="content-section">
				<div class="content-section-title">
					<span>04</span>
					<div>
						<small>RELATED JOBS</small>
						<h2>関連するIT職種</h2>
					</div>
				</div>

				<div class="related-card-grid">
					<c:forEach var="job" items="${jobList}">
						<a class="related-card"
							href="${pageContext.request.contextPath}/career/job?id=${job.jobId}">
							<strong>${job.jobName}</strong> <span>${job.summary}</span> <em>職種の詳細を見る
								→</em>
						</a>
					</c:forEach>
				</div>
			</section>
		</article>

		<section class="comment-section" id="comments">
			<div class="comment-heading">
				<div>
					<span class="kicker">COMMENTS & QUESTIONS</span>
					<h2>コメント・質問</h2>
				</div>
				<span>${fn:length(commentList)}件</span>
			</div>

			<div class="comment-list">
				<c:choose>
					<c:when test="${empty commentList}">
						<div class="empty-message">まだコメントはありません。この言語について気になることを質問できます。</div>
					</c:when>

					<c:otherwise>
						<c:forEach var="comment" items="${commentList}">
							<article id="comment-${comment.commentId}"
								class="comment-item ${comment.reply ? 'comment-reply' : ''}">
								<div class="comment-meta">
									<strong><c:out value="${comment.nickname}" /></strong>
									<c:if test="${comment.reply}"><span class="reply-badge">管理者からの返信</span></c:if>
									<span>${comment.regDate}</span>
								</div>
								<p><c:out value="${comment.content}" /></p>

								<c:if test="${not comment.reply and sessionScope.loginMember.role eq 'ADMIN'}">
									<details class="reply-box">
										<summary>返信する</summary>
										<form action="${pageContext.request.contextPath}/comment/reply" method="post">
											<input type="hidden" name="parentId" value="${comment.commentId}">
											<textarea name="content" rows="3" maxlength="1000"
												placeholder="返信を入力してください。" required></textarea>
											<div class="form-actions">
												<button class="btn primary" type="submit">返信する</button>
											</div>
										</form>
									</details>
								</c:if>

								<c:if test="${sessionScope.loginMember.id eq comment.memberId or sessionScope.loginMember.role eq 'ADMIN'}">
									<form action="${pageContext.request.contextPath}/comment/delete" method="post">
										<input type="hidden" name="commentId" value="${comment.commentId}">
										<input type="hidden" name="targetType" value="LANGUAGE">
										<input type="hidden" name="targetId" value="${language.languageId}">
										<button class="text-button" type="submit"
											onclick="return confirm('このコメントを削除しますか？');">削除</button>
									</form>
								</c:if>
							</article>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>

			<c:choose>
				<c:when test="${not empty sessionScope.loginMember}">
					<form class="comment-form"
						action="${pageContext.request.contextPath}/comment/write"
						method="post">
						<input type="hidden" name="targetType" value="LANGUAGE"> <input
							type="hidden" name="targetId" value="${language.languageId}">
						<label for="commentContent">この言語について質問・コメントする</label>
						<textarea id="commentContent" name="content" rows="4"
							maxlength="1000" placeholder="質問やコメントを入力してください。" required></textarea>
						<div class="form-actions">
							<button class="btn primary" type="submit">投稿する</button>
						</div>
					</form>
				</c:when>

				<c:otherwise>
					<div class="login-notice">
						<p>コメントを投稿するにはログインが必要です。</p>
						<a class="btn primary"
							href="${pageContext.request.contextPath}/member/login"> ログイン
						</a>
					</div>
				</c:otherwise>
			</c:choose>
		</section>
	</main>

	<jsp:include page="/include/footer.jsp" />

</body>
</html>
