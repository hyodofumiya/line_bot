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
    familyName=document.getElementById("familyName").value;
    firstName=document.getElementById("firstName").value;
    employeeNumber=document.getElementById("employeeNumber").value;
    //htmlでフォームのバリデーションに引っかかったらtrueが入る
    var checkValid=document.getElementById('signup_form').checkValidity();
    //バリデーションが問題なければ送信するかどうかの判断をする
    if (checkValid==true){
      liff.sendMessages([
        set_message(familyName, firstName, employeeNumber)
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

function set_message(familyName, firstName, employeeNumber){
  var newUserSendMessage=
  {
    "type": "flex",
    "altText": "Flex Message",
    "contents": {
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
          },
          {
            "type": "text",
            "text": "上記内容で登録しますか？",
            "margin": "xxl",
            "wrap": true
          }
        ]
      },
      "footer": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "button",
            "action": {
              "type": "message",
              "label": "はい",
              "text": "はい"
            },
            "style": "primary"
          },
          {
            "type": "separator",
            "margin": "md",
            "color": "#FFFFFF"
          },
          {
            "type": "button",
            "action": {
              "type": "message",
              "label": "いいえ",
              "text": "いいえ"
            },
            "style": "secondary"
          }
        ]
      }
    }
  };
  
  newUserSendMessage.contents.body.contents[1].contents[1].text = familyName;
  newUserSendMessage.contents.body.contents[2].contents[1].text = firstName;
  newUserSendMessage.contents.body.contents[4].text = employeeNumber;
  return newUserSendMessage;
}