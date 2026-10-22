
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>会員登録 | DevNavi</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/devnavi.css">
</head>

<body>

<jsp:include page="/include/header.jsp" />

<main class="auth-page">

    <section class="auth-card auth-card-wide">

        <span class="kicker">JOIN</span>

        <h1>会員登録</h1>

        <p class="auth-description">
            会員登録すると、職種・言語の記事で質問したり、
            管理者へお問い合わせできます。
        </p>

        <form id="joinForm"
              action="${pageContext.request.contextPath}/member/join"
              method="post"
              novalidate>

            <!-- ================================================
                 USER ID
                 ================================================ -->

            <label>
                <span>ユーザーID</span>

                <div class="inline-input">

                    <input type="text"
                           id="id"
                           name="id"
                           maxlength="20"
                           required>

                    <button class="btn"
                            id="idCheckBtn"
                            type="button">
                        重複確認
                    </button>

                </div>

                <small class="input-guide">
                    半角英数字4～20文字で入力してください。
                </small>

                <small id="idCheckMsg"
                       class="field-message">
                </small>
            </label>


            <!-- ================================================
                 PASSWORD
                 ================================================ -->

            <label>
                <span>パスワード</span>

                <input type="password"
                       id="pwd"
                       name="pwd"
                       maxlength="20"
                       required>

                <small class="input-guide">
                    半角英字と数字を含む8～20文字で入力してください。
                </small>

                <small id="pwdMsg"
                       class="field-message">
                </small>
            </label>


            <!-- ================================================
                 PASSWORD CHECK
                 ================================================ -->

            <label>
                <span>パスワード確認</span>

                <input type="password"
                       id="pwdCheck"
                       maxlength="20"
                       required>

                <small class="input-guide">
                    確認のため、同じパスワードを入力してください。
                </small>

                <small id="pwdCheckMsg"
                       class="field-message">
                </small>
            </label>


            <!-- ================================================
                 NICKNAME
                 ================================================ -->

            <label>
                <span>ニックネーム</span>

                <div class="inline-input">

                    <input type="text"
                           id="nickname"
                           name="nickname"
                           maxlength="20"
                           required>

                    <button class="btn"
                            id="nicknameCheckBtn"
                            type="button">
                        重複確認
                    </button>

                </div>

                <small class="input-guide">
                    サイト内で表示される名前です。2～20文字で入力してください。
                </small>

                <small id="nicknameCheckMsg"
                       class="field-message">
                </small>
            </label>


            <!-- ================================================
                 SUBMIT
                 ================================================ -->

            <button class="btn primary auth-submit"
                    type="submit">
                登録する
            </button>

        </form>


        <p class="auth-link">
            すでにアカウントをお持ちの方は
            <a href="${pageContext.request.contextPath}/member/login">
                ログイン
            </a>
        </p>

    </section>

</main>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>

$(function () {

    let idChecked = false;
    let nicknameChecked = false;


    // =========================================================
    // ID 중복 확인
    // =========================================================

    $("#idCheckBtn").on("click", function () {

        const id = $("#id").val().trim();

        const idPattern = /^[A-Za-z0-9]{4,20}$/;


        if (!idPattern.test(id)) {

            $("#idCheckMsg")
                .text("半角英数字4～20文字で入力してください。")
                .addClass("error");

            idChecked = false;

            return;
        }


        $.ajax({

            url:
                "${pageContext.request.contextPath}/member/idCheck",

            type:
                "get",

            data: {
                id: id
            },

            dataType:
                "json",

            success: function (result) {

                if (!result.valid) {

                    $("#idCheckMsg")
                        .text("IDの形式が正しくありません。")
                        .addClass("error");

                    idChecked = false;

                    return;
                }


                if (result.isDuplicate) {

                    $("#idCheckMsg")
                        .text("すでに使用されているIDです。")
                        .addClass("error");

                    idChecked = false;

                } else {

                    $("#idCheckMsg")
                        .text("使用できるIDです。")
                        .removeClass("error");

                    idChecked = true;
                }
            },

            error: function () {

                alert(
                    "通信エラーが発生しました。"
                );
            }
        });
    });


    // ID가 변경되면 다시 중복확인

    $("#id").on("input", function () {

        idChecked = false;

        $("#idCheckMsg")
            .text("");
    });



    // =========================================================
    // 비밀번호 입력 규칙 검사
    // =========================================================

    $("#pwd").on("input", function () {

        const pwd = $("#pwd").val();

        const pwdPattern =
            /^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{8,20}$/;


        if (pwd === "") {

            $("#pwdMsg")
                .text("")
                .removeClass("error");

            return;
        }


        if (pwd.length < 8 || pwd.length > 20) {

            $("#pwdMsg")
                .text("パスワードは8～20文字で入力してください。")
                .addClass("error");

        } else if (!/[A-Za-z]/.test(pwd)
                   || !/[0-9]/.test(pwd)) {

            $("#pwdMsg")
                .text("パスワードには英字と数字の両方を含めてください。")
                .addClass("error");

        } else if (!pwdPattern.test(pwd)) {

            $("#pwdMsg")
                .text("パスワードは半角英数字で入力してください。")
                .addClass("error");

        } else {

            $("#pwdMsg")
                .text("使用できるパスワードです。")
                .removeClass("error");
        }


        checkPasswordMatch();
    });



    // =========================================================
    // 비밀번호 일치 확인
    // =========================================================

    $("#pwdCheck").on("input", function () {

        checkPasswordMatch();
    });


    function checkPasswordMatch() {

        const pwd = $("#pwd").val();
        const pwdCheck = $("#pwdCheck").val();


        if (pwdCheck === "") {

            $("#pwdCheckMsg")
                .text("")
                .removeClass("error");

            return;
        }


        if (pwd === pwdCheck) {

            $("#pwdCheckMsg")
                .text("パスワードが一致しています。")
                .removeClass("error");

        } else {

            $("#pwdCheckMsg")
                .text("パスワードが一致していません。")
                .addClass("error");
        }
    }



    // =========================================================
    // 닉네임 중복 확인
    // =========================================================

    $("#nicknameCheckBtn").on("click", function () {

        const nickname =
            $("#nickname").val().trim();


        if (
            nickname.length < 2
            || nickname.length > 20
        ) {

            $("#nicknameCheckMsg")
                .text("2～20文字で入力してください。")
                .addClass("error");

            nicknameChecked = false;

            return;
        }


        $.ajax({

            url:
                "${pageContext.request.contextPath}/member/nicknameCheck",

            type:
                "get",

            data: {
                nickname: nickname
            },

            dataType:
                "json",

            success: function (result) {

                if (!result.valid) {

                    $("#nicknameCheckMsg")
                        .text("ニックネームの形式が正しくありません。")
                        .addClass("error");

                    nicknameChecked = false;

                    return;
                }


                if (result.isDuplicate) {

                    $("#nicknameCheckMsg")
                        .text("すでに使用されているニックネームです。")
                        .addClass("error");

                    nicknameChecked = false;

                } else {

                    $("#nicknameCheckMsg")
                        .text("使用できるニックネームです。")
                        .removeClass("error");

                    nicknameChecked = true;
                }
            },

            error: function () {

                alert(
                    "通信エラーが発生しました。"
                );
            }
        });
    });


    // 닉네임이 변경되면 다시 중복확인

    $("#nickname").on("input", function () {

        nicknameChecked = false;

        $("#nicknameCheckMsg")
            .text("");
    });



    // =========================================================
    // 회원가입 최종 검사
    // =========================================================

    $("#joinForm").on("submit", function (event) {

        const id =
            $("#id").val().trim();

        const pwd =
            $("#pwd").val();

        const pwdCheck =
            $("#pwdCheck").val();

        const nickname =
            $("#nickname").val().trim();


        const idPattern =
            /^[A-Za-z0-9]{4,20}$/;

        const pwdPattern =
            /^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{8,20}$/;


        // ID 형식

        if (!idPattern.test(id)) {

            $("#idCheckMsg")
                .text("半角英数字4～20文字で入力してください。")
                .addClass("error");

            $("#id").focus();

            event.preventDefault();

            return;
        }


        // ID 중복 확인 여부

        if (!idChecked) {

            $("#idCheckMsg")
                .text("ユーザーIDの重複確認をしてください。")
                .addClass("error");

            $("#id").focus();

            event.preventDefault();

            return;
        }


        // 비밀번호 입력 여부

        if (pwd === "") {

            $("#pwdMsg")
                .text("パスワードを入力してください。")
                .addClass("error");

            $("#pwd").focus();

            event.preventDefault();

            return;
        }


        // 비밀번호 규칙

        if (!pwdPattern.test(pwd)) {

            $("#pwdMsg")
                .text("パスワードは半角英字と数字を含む8～20文字で入力してください。")
                .addClass("error");

            $("#pwd").focus();

            event.preventDefault();

            return;
        }


        // 비밀번호 확인 입력

        if (pwdCheck === "") {

            $("#pwdCheckMsg")
                .text("確認用パスワードを入力してください。")
                .addClass("error");

            $("#pwdCheck").focus();

            event.preventDefault();

            return;
        }


        // 비밀번호 일치

        if (pwd !== pwdCheck) {

            $("#pwdCheckMsg")
                .text("パスワードが一致していません。")
                .addClass("error");

            $("#pwdCheck").focus();

            event.preventDefault();

            return;
        }


        // 닉네임 입력 규칙

        if (
            nickname.length < 2
            || nickname.length > 20
        ) {

            $("#nicknameCheckMsg")
                .text("ニックネームは2～20文字で入力してください。")
                .addClass("error");

            $("#nickname").focus();

            event.preventDefault();

            return;
        }


        // 닉네임 중복 확인

        if (!nicknameChecked) {

            $("#nicknameCheckMsg")
                .text("ニックネームの重複確認をしてください。")
                .addClass("error");

            $("#nickname").focus();

            event.preventDefault();

            return;
        }
    });

});

</script>


<jsp:include page="/include/footer.jsp" />

</body>
</html>
