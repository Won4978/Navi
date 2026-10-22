DevNavi 포트폴리오 수정본
========================

이 프로젝트는 사용자가 제공한 최신 DevNavi 프로젝트를 기준으로 보완한 버전입니다.

이번 수정 핵심
==============
- 기존 회원가입 / 로그인 / BCrypt / 닉네임 중복확인 유지
- 이메일 회원정보 제거 상태 유지
- 로그인 ID는 대소문자를 구분하지 않고 조회
- 댓글 삭제 전 확인창 유지
- 일반 회원: 직종/언어 상세페이지에서 댓글·질문 작성 및 본인 댓글 삭제
- 관리자: 원댓글에 1단계 답글(返信) 작성 가능
- 답글의 답글은 지원하지 않음
- 새 일반 댓글/질문 작성 시 관리자 미확인 알림 생성
- 새 문의 작성 시 관리자 미확인 알림 생성
- 관리자 헤더에 🔔 + 미확인 알림 개수 표시
- 알림 클릭 시 해당 댓글 또는 문의로 이동
- 문의 상세를 관리자가 열면 해당 문의 알림 확인 처리
- 댓글 알림을 열거나 답글을 작성하면 해당 댓글 알림 확인 처리
- 사용자 입력 댓글/문의 출력 시 c:out을 사용해 HTML 직접 출력 위험을 줄임

DB 주의
=======
이번 버전의 댓글/알림 기능에는 아래 컬럼이 필요합니다.
- CONTENT_COMMENT.PARENT_ID
- CONTENT_COMMENT.ADMIN_READ
- INQUIRY.ADMIN_READ

sql/devnavi_upgrade.sql에는 CONTENT_COMMENT / INQUIRY를 새 구조로 다시 만드는 SQL과
기존 직종/언어 콘텐츠 UPDATE가 포함되어 있습니다.

사용자가 전체 DB를 새로 구성할 예정이므로, 기존 MEMBER / JOB / PROGRAMMING_LANGUAGE /
JOB_LANGUAGE까지 삭제한 경우에는 이 upgrade SQL만 단독 실행하면 안 됩니다.
전체 DB 재생성 SQL은 프로젝트 최종 확인 후 별도로 맞추면 됩니다.

관리자 계정
===========
회원가입 후 예시:

UPDATE member SET role='ADMIN' WHERE id='Navi1234';
COMMIT;

실행 환경
=========
- Eclipse
- Tomcat 10.1
- Oracle 11g XE
- context root: devnavi
- 시작 주소: http://localhost:8090/devnavi/home/main

Eclipse에서 새 수정본을 가져온 뒤 Project > Clean을 한 번 실행하는 것을 권장합니다.

GitHub 공개 전 주의
==================
util/DB.java에는 현재 로컬 개발용 DB 접속정보가 들어 있습니다.
GitHub 공개 전 DB 비밀번호는 환경변수 또는 별도 로컬 설정으로 분리하세요.
