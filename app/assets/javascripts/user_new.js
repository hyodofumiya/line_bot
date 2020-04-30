window.addEventListener('turbolinks:load', initializeLiff)
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
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}
//LIFFの機能------------------------------------------------------------------------------------
function sendMessage(){
  //メッセージ送信機能
  document.getElementById("sendMessageButton").addEventListener('click', function(){
    var familyName=document.getElementById("familyName").value;
    var firstName=document.getElementById("firstName").value;
    var employeeNumber=document.getElementById("employeeNumber").value;
    //htmlでフォームのバリデーションに引っかかったらtrueが入る
    var checkValid=document.getElementById('signup_form').checkValidity();
    //バリデーションが問題なければ送信するかどうかの判断をする
    if (checkValid==true){
      liff.sendMessages([
      {
        type:'text',
        text:"Hello, World!${familyName}"
      }
      ])
      .then(() => {
        console.log('message sent');
      })
      .catch((err) => {
        console.log('error', err);
      });
    }
  })
}