window.addEventListener('turbolinks:load', judgeUserNewApp);

function judgeUserNewApp(){
  //呼び出したいLIFFアプリをuriから特定
  let userNewLiffPass = "/usernew";
  if (location.pathname == userNewLiffPass){
    initializeUserNewLiff();
  };
}
//LIFFを起動----------------------------------------------------------------------------------
function initializeUserNewLiff() {
  MyLiffId= "1654154094-L2PYjd9P";
  liff
    .init({
      liffId: MyLiffId
    })
    .then(() => {
      sendMessage('signup_form');
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}

function sendMessage(formId){
  //メッセージ送信機能
  $("#signup_form").on('submit', function(event){
    event.preventDefault();
    //htmlでフォームのバリデーションに引っかかったらfalse,問題なければtrueが入る
    var checkValid = document.getElementById('signup_form').checkValidity();
    //バリデーションが問題なければ送信するかどうかの判断をする
    if (checkValid == true){
      var userIdToken = liff.getIDToken();
      document.getElementById("userIdToken").value = userIdToken;
      var formData = new FormData(this);
      var url = $(this).attr('action');
      $.ajax({
        url: url,
        type: "POST",
        data: formData,
        dataType: 'json',
        processData: false,
        contentType: false
      })
      .success(function(data){
        liff.closeWindow();
      })
      .error(function(){
        alert("失敗しました。")
      })
    }
    return false;
  });
}



