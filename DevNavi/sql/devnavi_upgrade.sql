-- ============================================================
-- DevNavi comment / inquiry feature SQL (final portfolio version)
-- DEVNAVI 계정으로 실행하세요.
-- 사용자가 DB를 새로 만들 예정이므로 CONTENT_COMMENT / INQUIRY를
-- 삭제 후 다시 만드는 형태입니다.
-- MEMBER / JOB / PROGRAMMING_LANGUAGE / JOB_LANGUAGE는 유지합니다.
-- ============================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE content_comment CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_content_comment';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE inquiry CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_inquiry';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

CREATE TABLE content_comment (
    comment_id NUMBER NOT NULL,
    member_id VARCHAR2(20) NOT NULL,
    target_type VARCHAR2(10) NOT NULL,
    target_id NUMBER NOT NULL,
    parent_id NUMBER,
    content VARCHAR2(1000) NOT NULL,
    admin_read CHAR(1) DEFAULT 'N' NOT NULL,
    reg_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_content_comment PRIMARY KEY (comment_id),
    CONSTRAINT fk_comment_member FOREIGN KEY (member_id)
        REFERENCES member(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_id)
        REFERENCES content_comment(comment_id) ON DELETE CASCADE,
    CONSTRAINT ck_comment_target_type CHECK (target_type IN ('JOB', 'LANGUAGE')),
    CONSTRAINT ck_comment_admin_read CHECK (admin_read IN ('Y', 'N'))
);

CREATE SEQUENCE seq_content_comment START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE inquiry (
    inquiry_id NUMBER NOT NULL,
    member_id VARCHAR2(20) NOT NULL,
    title VARCHAR2(200) NOT NULL,
    content VARCHAR2(3000) NOT NULL,
    answer VARCHAR2(3000),
    status VARCHAR2(10) DEFAULT 'WAITING' NOT NULL,
    admin_read CHAR(1) DEFAULT 'N' NOT NULL,
    reg_date DATE DEFAULT SYSDATE NOT NULL,
    answer_date DATE,
    CONSTRAINT pk_inquiry PRIMARY KEY (inquiry_id),
    CONSTRAINT fk_inquiry_member FOREIGN KEY (member_id)
        REFERENCES member(id) ON DELETE CASCADE,
    CONSTRAINT ck_inquiry_status CHECK (status IN ('WAITING', 'ANSWERED')),
    CONSTRAINT ck_inquiry_admin_read CHECK (admin_read IN ('Y', 'N'))
);

CREATE SEQUENCE seq_inquiry START WITH 1 INCREMENT BY 1 NOCACHE;

COMMIT;


-- ------------------------------------------------------------
-- 직종 콘텐츠
-- ------------------------------------------------------------

UPDATE job
SET summary = q'~WebサイトやWebアプリケーションで、ユーザーが直接操作する画面部分を開発するエンジニアです。~',
    description = q'~フロントエンドエンジニアは、Webサービスの中でユーザーの目に見え、実際に操作する部分を開発する職種です。
デザインをもとに画面を実装するだけでなく、ボタンやメニューの動作、入力フォーム、APIから取得したデータの表示なども担当します。
PCやスマートフォンなど異なる画面サイズでも使いやすく表示できるように調整し、見た目と使いやすさの両方を意識してサービスを形にしていきます。~',
    main_tasks = q'~・HTML、CSS、JavaScriptを使ったWeb画面の実装
・ボタン、メニュー、フォームなどのUI機能の開発
・APIから取得したデータの画面表示
・PCやスマートフォンなど複数の画面サイズへの対応
・表示速度や操作性を意識したUI・UXの改善~',
    recommended_for = q'~・自分が作ったものを画面で確認しながら開発したい人
・WebサイトやWebサービスの仕組みに興味がある人
・デザインやUI・UXにも関心がある人
・ユーザーにとって使いやすいサービスを作りたい人~'
WHERE job_id = 1;

UPDATE job
SET summary = q'~サーバーやデータベース、APIなど、Webサービスの裏側で動く仕組みを開発するエンジニアです。~',
    description = q'~バックエンドエンジニアは、WebサイトやWebアプリケーションの「裏側」で動くシステムを開発する職種です。
例えばログイン、会員登録、商品検索、予約、注文などの機能では、画面から送られた情報を受け取り、必要な処理を行い、データベースへ保存したり結果を画面へ返したりします。
ユーザーから直接見えない部分を担当しますが、サービスを安全かつ安定して動かすために欠かせない役割です。~',
    main_tasks = q'~・会員登録、ログイン、検索、予約などの機能開発
・データベースへの登録、検索、更新、削除処理
・フロントエンドや外部サービスと連携するAPIの開発
・認証やアクセス制御などセキュリティを意識した実装
・システム公開後の不具合修正や性能改善~',
    recommended_for = q'~・システムが内部でどのように動くのか考えることが好きな人
・データベースやサーバー側の処理に興味がある人
・論理的に問題を整理して解決することが好きな人
・見た目よりも機能や仕組みを作ることに興味がある人~'
WHERE job_id = 2;

UPDATE job
SET summary = q'~機械学習やAI技術を利用し、予測・分類・生成などを行うシステムやサービスを開発するエンジニアです。~',
    description = q'~AIエンジニアは、機械学習や深層学習などの技術を使って、データから特徴や規則を学習するシステムを開発する職種です。
画像認識、文章生成、需要予測、異常検知、推薦システムなど活用分野は広く、モデルを作るだけでなく、データの準備や評価、実際のサービスへの組み込みまで担当する場合があります。
AIの仕組みを理解するための数学・統計の基礎と、データを扱うプログラミング能力の両方が重要になります。~',
    main_tasks = q'~・学習に使用するデータの収集、整理、前処理
・機械学習モデルの設計、学習、評価
・予測精度や処理性能を改善するための検証
・学習済みモデルをWebサービスや業務システムへ組み込む
・新しいAI技術や論文を調査し、実務への活用方法を検討する~',
    recommended_for = q'~・AIや機械学習の仕組みに興味がある人
・データを分析して規則や傾向を見つけることが好きな人
・数学や統計を学ぶことに抵抗がない人
・試行錯誤しながら精度を改善する作業を楽しめる人~'
WHERE job_id = 3;

UPDATE job
SET summary = q'~大量のデータを収集・加工・管理し、分析やサービスで利用できるデータ基盤を構築するエンジニアです。~',
    description = q'~データエンジニアは、社内外に存在するさまざまなデータを集め、必要な形に加工し、安全に保存して利用できる環境を作る職種です。
分析担当者やAIエンジニアが正しいデータを効率よく利用できるように、データの流れやデータベース、処理基盤を設計します。
データ量が増えても安定して処理できる仕組みや、品質の高いデータを維持するための設計が重要です。~',
    main_tasks = q'~・複数のシステムからデータを収集する処理の開発
・分析しやすい形へデータを変換、加工する処理の構築
・データベースやデータウェアハウスの設計、運用
・大量データを安定して処理するデータパイプラインの構築
・欠損や重複などを確認し、データ品質を維持する仕組みの整備~',
    recommended_for = q'~・データベースや大量データの処理に興味がある人
・整理された仕組みを作ることが好きな人
・SQLを使ったデータ操作を深く学びたい人
・分析やAIを支える基盤側の仕事に興味がある人~'
WHERE job_id = 4;

UPDATE job
SET summary = q'~サーバー、ネットワーク、クラウドなど、システムを動かすためのIT基盤を設計・構築・運用するエンジニアです。~',
    description = q'~インフラ・クラウドエンジニアは、Webサービスや業務システムが安定して動き続けるための基盤を担当する職種です。
サーバーやネットワークを準備するだけでなく、現在はAWSなどのクラウド環境を利用して必要なリソースを設計・構築する仕事も増えています。
障害を未然に防ぐ監視やバックアップ、作業を自動化する仕組みづくりなど、サービスの安定性を支える役割があります。~',
    main_tasks = q'~・サーバーやネットワーク環境の設計、構築
・クラウドサービスを利用したシステム基盤の構築
・システムの監視、障害対応、バックアップ
・設定作業や運用作業を自動化するスクリプトの作成
・セキュリティやコストを考慮したインフラ環境の改善~',
    recommended_for = q'~・コンピューターやネットワークの仕組みに興味がある人
・サービスを安定して支える仕事に魅力を感じる人
・自動化や効率化を考えることが好きな人
・トラブルの原因を一つずつ調査することが苦にならない人~'
WHERE job_id = 5;

UPDATE job
SET summary = q'~システムやネットワークをサイバー攻撃や情報漏えいなどの脅威から守るエンジニアです。~',
    description = q'~セキュリティエンジニアは、企業のシステムやデータをさまざまな脅威から守るために、弱点の調査や対策、監視を行う職種です。
攻撃方法だけを知るのではなく、ネットワーク、OS、Webアプリケーション、認証など幅広いIT知識を組み合わせて安全性を高めます。
問題が起きてから対応するだけでなく、設計段階からリスクを考え、事故を防ぐ仕組みを作ることも重要です。~',
    main_tasks = q'~・システムやネットワークの脆弱性調査
・不正アクセスや攻撃を検知するための監視
・安全な認証、権限、ネットワーク構成の設計
・セキュリティ事故が発生した際の原因調査と対応
・開発者や利用者へ安全な運用方法を共有する~',
    recommended_for = q'~・セキュリティやサイバー攻撃の仕組みに興味がある人
・細かな違いや異常に気づくことが得意な人
・ネットワークやOSを幅広く学びたい人
・新しい脅威や技術を継続して学べる人~'
WHERE job_id = 6;

UPDATE job
SET summary = q'~ゲームのルールや操作、画面表現などをプログラムとして実装し、ゲームを動かすエンジニアです。~',
    description = q'~ゲームエンジニアは、企画やデザインを実際に遊べるゲームとして動かすためのプログラムを開発する職種です。
キャラクター操作、戦闘、物理演算、AI、画面表示、通信など担当領域は幅広く、ゲームエンジンを利用して開発する場合も多くあります。
面白さだけでなく、限られたハードウェア性能の中で滑らかに動かすための処理性能も重要になります。~',
    main_tasks = q'~・キャラクター操作やゲームルールの実装
・敵キャラクターのAIやゲーム内システムの開発
・グラフィック、サウンド、UIなど各機能の連携
・処理速度やメモリ使用量を考慮した最適化
・不具合の調査、修正、ゲームバランス調整への対応~',
    recommended_for = q'~・ゲームがどのような仕組みで動いているか興味がある人
・プログラムで動きや表現を作ることが好きな人
・処理性能やアルゴリズムにも関心がある人
・企画、デザインなど他職種と協力してものづくりをしたい人~'
WHERE job_id = 7;

UPDATE job
SET summary = q'~機械や装置に組み込まれるソフトウェアや、工場の自動化設備・ロボットなどを制御するシステムを開発するエンジニアです。~',
    description = q'~組み込み・制御エンジニアは、自動車、家電、産業機械、ロボットなどの機器を動かすためのソフトウェアを開発する職種です。
Web開発とは異なり、センサーやモーターなど実際のハードウェアと連携しながら、決められた時間内に正確な処理を行うことが求められます。
製造現場の自動化設備では、機械の動作や安全性、生産効率まで考えながら制御システムを作るため、製造業の知識を活かしやすい分野でもあります。~',
    main_tasks = q'~・機器や装置に組み込まれる制御プログラムの開発
・センサー、モーター、通信機器などハードウェアとの連携
・工場の自動化設備やロボットの動作制御
・限られたメモリや処理性能を考慮したプログラム設計
・実機を使った動作確認、不具合解析、安全性の検証~',
    recommended_for = q'~・機械が実際に動くものづくりに興味がある人
・製造業や工場設備の経験をIT分野でも活かしたい人
・ハードウェアとソフトウェアの両方に関心がある人
・正確性や安全性を意識して細かく確認することが得意な人~'
WHERE job_id = 8;

-- ------------------------------------------------------------
-- 언어 콘텐츠
-- ------------------------------------------------------------

UPDATE programming_language
SET summary = q'~Webアプリケーションや企業の業務システムなど、幅広い分野で長く利用されているプログラミング言語です。~',
    description = q'~Javaは、さまざまな環境で同じプログラムを動かしやすいことを重視して設計されたプログラミング言語です。
企業の業務システムや大規模なWebサービスで多く利用され、長期間運用されるシステムでも採用例が豊富です。
オブジェクト指向を学びながら、データベースやWebアプリケーション開発へ学習範囲を広げやすく、バックエンドエンジニアを目指す際の代表的な選択肢の一つです。~',
    features = q'~・オブジェクト指向を中心とした設計を学べる
・企業向けシステムや大規模サービスでの採用例が多い
・豊富なライブラリやフレームワークを利用できる
・JVM上で動作し、さまざまな環境で利用しやすい~',
    usage_field = q'~企業の業務システム、Webサービスのバックエンド、金融・公共系システムなどで広く利用されています。Javaの基礎を身につけた後は、SQL、Webの仕組み、Servlet/JSP、Springなどへ学習を広げることで実際のWeb開発につながります。~'
WHERE language_id = 1;

UPDATE programming_language
SET summary = q'~Webページに動きや操作機能を加え、ブラウザ上で動くアプリケーションを作るために欠かせない言語です。~',
    description = q'~JavaScriptは、Webブラウザ上で動作する代表的なプログラミング言語です。
ボタンを押したときの処理、入力内容の確認、画面の一部だけを更新する処理など、ユーザーが操作するWeb画面の多くで利用されています。
現在はブラウザだけでなくサーバー側の開発にも利用でき、Web開発を学ぶ上で非常に重要な言語です。~',
    features = q'~・主要なWebブラウザで標準的に利用できる
・HTMLやCSSと組み合わせて動的な画面を作れる
・非同期通信を使ってページを再読み込みせずデータを更新できる
・豊富なライブラリやフレームワークが存在する~',
    usage_field = q'~Webサイト、Webアプリケーションのフロントエンド開発で特に広く利用されています。HTMLとCSSの基礎を学んだ後にJavaScriptを学ぶと、画面表示からユーザー操作までの流れを理解しやすくなります。~'
WHERE language_id = 2;

UPDATE programming_language
SET summary = q'~JavaScriptに型の仕組みを加え、大規模なWebアプリケーションでも安全に開発しやすくしたプログラミング言語です。~',
    description = q'~TypeScriptはJavaScriptを拡張して作られたプログラミング言語で、変数や関数が扱うデータの型を明確にできることが大きな特徴です。
コードを書く段階で間違いを発見しやすく、複数人で開発する大きなWebアプリケーションでもコードの意図を共有しやすくなります。
最終的にはJavaScriptへ変換して実行されるため、JavaScriptの基礎を理解した上で学ぶと関係性を理解しやすくなります。~',
    features = q'~・JavaScriptの機能を利用しながら型を指定できる
・実行前に多くのミスを発見しやすい
・大規模開発やチーム開発でコードを管理しやすい
・JavaScriptの主要なフレームワークと組み合わせて利用できる~',
    usage_field = q'~中規模から大規模なWebフロントエンド開発で多く利用されています。JavaScriptの基本文法やDOM操作を理解した後にTypeScriptへ進むと、型を使う理由や開発上のメリットを理解しやすくなります。~'
WHERE language_id = 3;

UPDATE programming_language
SET summary = q'~読みやすい文法を持ち、AI、データ分析、Web開発、自動化など多くの分野で利用されている言語です。~',
    description = q'~Pythonは、比較的シンプルで読みやすい文法を持つプログラミング言語です。
AIや機械学習、データ分析で有名ですが、Webアプリケーション、業務の自動化、インフラ運用などにも利用されています。
目的に応じたライブラリが豊富で、少ないコードから試しやすいため、プログラミングの考え方を学ぶ最初の言語として選ばれることもあります。~',
    features = q'~・文法が比較的シンプルでコードを読みやすい
・AIやデータ分析向けのライブラリが充実している
・Web開発や自動化など幅広い用途に利用できる
・試作や検証を短いコードで始めやすい~',
    usage_field = q'~AI・機械学習、データ分析、データ処理、Webバックエンド、インフラ運用の自動化などで利用されています。目指す職種によって、基礎文法の後に学ぶライブラリや技術が大きく変わる言語です。~'
WHERE language_id = 4;

UPDATE programming_language
SET summary = q'~ハードウェアに近い処理を細かく制御でき、組み込みシステムや制御分野で長く利用されている言語です。~',
    description = q'~C言語は、コンピューターのメモリやハードウェアに近い部分を意識しながらプログラムを作れる言語です。
現在でもマイコン、家電、自動車、産業機械などの組み込み開発で広く利用されています。
ポインタやメモリ管理など初学者には難しい概念もありますが、コンピューターが内部でどのようにデータを扱うのか理解する助けになります。~',
    features = q'~・ハードウェアに近い低レベルな処理を記述できる
・小さな機器でも動かしやすく処理性能を細かく調整できる
・組み込みやOSなど基盤技術で長く利用されている
・メモリやポインタを学ぶことでコンピューターの仕組みを理解しやすい~',
    usage_field = q'~マイコン、家電、自動車、産業機械などの組み込み・制御システムで特に重要です。また、OSやセキュリティを深く理解する際にもC言語の知識が役立ちます。~'
WHERE language_id = 5;

UPDATE programming_language
SET summary = q'~C言語の性能を活かしながらオブジェクト指向などの機能を利用でき、ゲームや高性能システムで使われる言語です。~',
    description = q'~C++はC言語を基礎に発展したプログラミング言語で、高い処理性能と大規模なプログラムを設計するための機能をあわせ持っています。
ゲーム、組み込み、画像処理、シミュレーションなど、速度やメモリ効率が重要な分野で利用されています。
扱える機能が多い分、学習範囲は広いですが、性能を意識した本格的なソフトウェア開発につながる言語です。~',
    features = q'~・高い処理性能が求められるシステムに向いている
・オブジェクト指向など大規模開発向けの機能を利用できる
・メモリや処理方法を細かく制御できる
・ゲームエンジンや組み込み開発など専門分野で利用される~',
    usage_field = q'~ゲーム開発、ゲームエンジン、組み込みシステム、ロボット、画像処理などで利用されています。C言語の基礎知識があると、C++特有の機能との違いを理解しやすくなります。~'
WHERE language_id = 6;

UPDATE programming_language
SET summary = q'~Microsoftの.NET環境を中心に、ゲーム開発や業務アプリケーションなどで利用されている言語です。~',
    description = q'~C#は、読みやすさと開発のしやすさを重視したオブジェクト指向のプログラミング言語です。
.NETの豊富な機能を利用して業務アプリケーションやWebサービスを開発できるほか、Unityを使ったゲーム開発でも広く利用されています。
Javaと似た文法も多く、オブジェクト指向を学びながら実用的なアプリケーション開発へ進みやすい言語です。~',
    features = q'~・オブジェクト指向を使って構造的にプログラムを設計できる
・.NETの豊富なライブラリを利用できる
・Unityを利用したゲーム開発で広く使われている
・デスクトップ、Web、ゲームなど複数の分野で利用できる~',
    usage_field = q'~Unityによるゲーム開発、企業向け業務アプリケーション、Webシステムなどで利用されています。ゲームエンジニアを目指す場合は、C#の文法とあわせてUnityの基本操作を学ぶ流れが代表的です。~'
WHERE language_id = 7;

UPDATE programming_language
SET summary = q'~データベースに保存されたデータを検索・登録・更新・削除するために利用されるデータ操作言語です。~',
    description = q'~SQLは、リレーショナルデータベースに保存されたデータを操作するための言語です。
一般的なプログラミング言語とは役割が異なり、必要なデータを検索したり、新しいデータを登録したり、既存データを更新・削除したりするために使用します。
Webサービスや業務システムではデータベースを利用する場面が非常に多いため、バックエンドやデータ分野を目指す人にとって重要な基礎知識です。~',
    features = q'~・SELECTを使って必要なデータを検索できる
・INSERT、UPDATE、DELETEでデータを変更できる
・複数のテーブルをJOINして関連する情報を取得できる
・集計や並び替えを使ってデータを分析しやすい形にできる~',
    usage_field = q'~Webサービスのバックエンド、企業の業務システム、データ分析、データ基盤など幅広い分野で利用されます。JavaやPythonなどと組み合わせて学ぶことで、アプリケーションからデータベースを操作する流れを理解できます。~'
WHERE language_id = 8;

COMMIT;

-- ------------------------------------------------------------
-- 관리자 권한 설정
-- 회원가입 후, 관리자 계정으로 사용할 ID를 아래 YOUR_ID 대신 입력하고 실행하세요.
-- 예: UPDATE member SET role='ADMIN' WHERE id='jaewon';
-- ------------------------------------------------------------
-- UPDATE member SET role='ADMIN' WHERE id='YOUR_ID';
-- COMMIT;
