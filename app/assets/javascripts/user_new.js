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

    //htmlでフォームのバリデーションに引っかかったらtrueが入る
    var checkValid=document.getElementById('signup_form').checkValidity();      
      //バリデーションが問題なければ送信するかどうかの判断をする
    if (checkValid==true){
      //
      //var firstName = document.getElementById('firstName').getAttribute('value');
      //var familyName = document.getElementById('familyName').getAttribute('value');
      //var employeeNumber = document.getElementById('employeeNumber').getAttribute('value');
      //var seme = set_form_message(firstName,familyName,employeeNumber);
      //debugger
      liff.sendMessages([{
        "type":"text",
        "text":"tee"
      }])
      .then(() => {
        alert("送信しました");
        console.log('message sent');
      })
      .catch((err) => {
        alert(err);
        console.log('error', err);
      });
    }
  })
}




function set_form_message(firstName, familyName, employeeNumber){
  var newUserSendMessage = {
    "type": "bubble",
    "direction": "ltr",
    "header": {
      "type": "box",
      "layout": "vertical",
      "contents": [
        {
          "type": "text",
          "text": "入力内容の確認",
          "margin": "none",
          "size": "xl",
          "align": "center",
          "weight": "bold",
          "color": "#767474"
        },
        {
          "type": "separator"
        }
      ]
    },
    "body": {
      "type": "box",
      "layout": "vertical",
      "flex": 0,
      "spacing": "none",
      "margin": "none",
      "contents": [
        {
          "type": "text",
          "text": "氏名",
          "size": "lg"
        },
        {
          "type": "box",
          "layout": "horizontal",
          "contents": [
            {
              "type": "text",
              "text": "姓:　",
              "flex": 0,
              "align": "start",
              "weight": "regular",
              "color": "#787878"
            },
            {
              "type": "text",
              "text": "familyName",
              "align": "start",
              "weight": "regular",
              "wrap": true
            }
          ]
        },
        {
          "type": "box",
          "layout": "horizontal",
          "contents": [
            {
              "type": "text",
              "text": "名:　",
              "flex": 0,
              "margin": "none",
              "color": "#787878"
            },
            {
              "type": "text",
              "text": "firstName",
              "align": "start",
              "wrap": true
            }
          ]
        },
        {
          "type": "text",
          "text": "社員番号",
          "margin": "md",
          "size": "lg"
        },
        {
          "type": "text",
          "text": "employeeNumber"
        }
      ]
    }
  };
  newUserSendMessage.body.contents[1].contents[1].text = firstName;
  newUserSendMessage.body.contents[1].contents[1].text = familyName;
  newUserSendMessage.body.contents[4].text = employeeNumber;
  return newUserSendMessage;
}