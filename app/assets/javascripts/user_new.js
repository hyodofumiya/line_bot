window.addEventListener('turbolinks:load', judgeUserNewApp);

function judgeUserNewApp(){
  //呼び出したいLIFFアプリをuriから特定
  var referrer = document.referrer;
  let userNewLiffPass = "https://liff.line.me/1654154094-1nd8zDod";
  if (referrer == userNewLiffPass){
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



