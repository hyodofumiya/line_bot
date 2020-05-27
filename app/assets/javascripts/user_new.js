//window.addEventListener('turbolinks:load', initializeLiff)

//LIFFを起動----------------------------------------------------------------------------------
function initializeLiff() {
  console.log("test1");
  MyLiffId= "1654154094-L2PYjd9P";
  liff
    .init({
      liffId: MyLiffId
    })
    .then(() => {
      sendMessage();
      liff.closeWindow();
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}
//LIFFの機能------------------------------------------------------------------------------------
function sendMessage(){
  //メッセージ送信機能
  document.getElementById("sendMessageButton").addEventListener('click', function(){
    //htmlでフォームのバリデーションに引っかかったらfalse,問題なければtrueが入る
    var checkValid=document.getElementById('signup_form').checkValidity();
    //バリデーションが問題なければ送信するかどうかの判断をする
    if (checkValid==true){
      var userIdToken = liff.getIDToken();
      document.getElementById("userIdToken").value = userIdToken;
    }
  })
}



