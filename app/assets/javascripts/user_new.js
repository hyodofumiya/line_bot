window.addEventListener('turbolinks:load', initializeLiff)

function initializeLiff() {
  //var userId = data.context.userId
  console.log("test1");
  liff
    .init({
        liffId: "1654154094-L2PYjd9P"
    })
    .then(() => {
        initializeApp(userId);
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}

function initializeApp(userId){
  //送信
  document.getElementById("sendMessageButton").addEventListener('click', function(){
    liff.sendMessages([
    {
      type:'text',
      text:'Hello, World!'
    }
    ])
    .then(() => {
      console.log('message sent');
    })
    .catch((err) => {
      console.log('error', err);
    });
  })
}

