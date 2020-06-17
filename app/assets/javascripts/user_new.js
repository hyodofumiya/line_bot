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
      liff.closeWindow();
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}

function sendMessage(formId){
  //メッセージ送信機能
  document.getElementById("sendMessageButton").addEventListener('click', function(){
    //htmlでフォームのバリデーションに引っかかったらfalse,問題なければtrueが入る
    var checkValid=document.getElementById(formId).checkValidity();
    //バリデーションが問題なければ送信するかどうかの判断をする
    if (checkValid==true){
      var userIdToken = liff.getIDToken();
      document.getElementById("userIdToken").value = userIdToken;
    }
  })
}