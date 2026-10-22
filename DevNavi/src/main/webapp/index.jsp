<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ja">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>DevNavi | IT職種とプログラミング言語を知る</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/devnavi.css">
</head>

<body>

	<jsp:include page="/include/header.jsp" />


	<main>

		<!-- =====================================================
         HERO
         ===================================================== -->

		<section class="hero">

			<div class="hero-inner">

				<span class="eyebrow"> IT CAREER EXPLORER </span>

				<h1>
					職種から、言語まで。<br> 自分のITキャリアを見つけよう。
				</h1>

				<p>IT職種とプログラミング言語の関係をわかりやすく紹介する、 学習・キャリア選択のための情報サイトです。</p>

				<div class="actions">

					<a class="btn primary"
						href="${pageContext.request.contextPath}/career/jobs"> 職種から探す
					</a> <a class="btn"
						href="${pageContext.request.contextPath}/career/languages">
						言語から探す </a>

				</div>

			</div>

		</section>


		<!-- =====================================================
         CHAPTER 01
         JOBS
         ===================================================== -->

		<section class="chapter chapter-jobs">

			<div class="section">

				<div class="chapter-label">CHAPTER 01</div>

				<div class="section-head">

					<div>

						<span class="kicker"> JOBS </span>

						<h2>IT職種を知る</h2>

						<p>仕事内容から、自分が興味を持てるITキャリアを探してみましょう。</p>

					</div>

					<a href="${pageContext.request.contextPath}/career/jobs"> すべて見る
						→ </a>

				</div>


				<!-- JOB SLIDER -->

				<div class="home-slider">

					<button type="button" class="slider-btn slider-prev"
						data-slider="jobSlider" aria-label="前の職種を見る">‹</button>


					<div class="slider-viewport">

						<div class="slider-track" id="jobSlider">

							<c:forEach var="job" items="${jobList}">

								<a class="card slider-card"
									href="${pageContext.request.contextPath}/career/job?id=${job.jobId}">

									<span class="num"> 0${job.jobId} </span>

									<h3>${job.jobName}</h3>

									<p>${job.summary}</p> <span class="more"> 詳しく見る → </span>

								</a>

							</c:forEach>

						</div>

					</div>


					<button type="button" class="slider-btn slider-next"
						data-slider="jobSlider" aria-label="次の職種を見る">›</button>

				</div>

			</div>

		</section>


		<!-- =====================================================
         CHAPTER 02
         LANGUAGES
         ===================================================== -->

		<section class="chapter chapter-languages">

			<div class="section">

				<div class="chapter-label">CHAPTER 02</div>

				<div class="section-head">

					<div>

						<span class="kicker"> LANGUAGES </span>

						<h2>プログラミング言語を知る</h2>

						<p>言語の特徴や活用分野から、どのIT職種につながるのか確認できます。</p>

					</div>

					<a href="${pageContext.request.contextPath}/career/languages">
						すべて見る → </a>

				</div>


				<!-- LANGUAGE SLIDER -->

				<div class="home-slider">

					<button type="button" class="slider-btn slider-prev"
						data-slider="languageSlider" aria-label="前の言語を見る">‹</button>


					<div class="slider-viewport">

						<div class="slider-track" id="languageSlider">

							<c:forEach var="lang" items="${languageList}">

								<a class="card language-card slider-card"
									href="${pageContext.request.contextPath}/career/language?id=${lang.languageId}">

									<span class="language-mark"> ${lang.languageName} </span>

									<h3>${lang.languageName}</h3>

									<p>${lang.summary}</p> <span class="more"> 詳しく見る → </span>

								</a>

							</c:forEach>

						</div>

					</div>


					<button type="button" class="slider-btn slider-next"
						data-slider="languageSlider" aria-label="次の言語を見る">›</button>

				</div>

			</div>

		</section>

	</main>


	<jsp:include page="/include/footer.jsp" />


	<!-- =========================================================
     HOME SLIDER SCRIPT
     ========================================================= -->

	<script>
		document.addEventListener("DOMContentLoaded", function() {

			const sliders = document.querySelectorAll(".slider-track");

			sliders.forEach(function(slider) {

				const prevButton = document
						.querySelector('.slider-prev[data-slider="' + slider.id
								+ '"]');

				const nextButton = document
						.querySelector('.slider-next[data-slider="' + slider.id
								+ '"]');

				let currentPage = 0;

				const cards = slider.querySelectorAll(".slider-card");

				const itemsPerPage = 4;

				const totalPages = Math.ceil(cards.length / itemsPerPage);

				function moveSlider() {

					const pageWidth = slider.parentElement.clientWidth;

					const gap = 18;

					const moveAmount = currentPage * (pageWidth + gap);

					slider.style.transform = "translateX(-" + moveAmount
							+ "px)";

					prevButton.disabled = currentPage === 0;

					nextButton.disabled = currentPage >= totalPages - 1;
				}

				prevButton.addEventListener("click", function() {

					if (currentPage > 0) {

						currentPage--;

						moveSlider();
					}

				});

				nextButton.addEventListener("click", function() {

					if (currentPage < totalPages - 1) {

						currentPage++;

						moveSlider();
					}

				});

				window.addEventListener("resize", function() {

					moveSlider();

				});

				moveSlider();

			});

		});
	</script>


</body>

</html>