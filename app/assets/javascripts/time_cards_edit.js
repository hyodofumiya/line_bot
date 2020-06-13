window.addEventListener('turbolinks:load', judgeTimeCardEditApp);

var timecard_data;

function judgeTimeCardEditApp(){
  //呼び出したいLIFFアプリをuriから特定
  var referrer = document.referrer;
  let timecardEditPass = "https://liff.line.me/1654154094-1nd8zDod";
  //if (referrer == timecardEditPass){
  initializeTimeCardEditLiff();
  //};
}

//LIFFを起動----------------------------------------------------------------------------------
function initializeTimeCardEditLiff() {
  MyLiffId= "1654154094-1nd8zDod";
  liff
    .init({
      liffId: MyLiffId
    })
    .then(() => {
      //日付が変更されるとuserを確認しtimecardのレコードを返す関数
      timecard_data = return_timecard();
      //日付に値が入ると他のフォームを選択可能にする関数
      judgeDateFormStatus();
      judgeWorktime();
      changeSubmitBtnStatus();
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}
//LIFFの機能------------------------------------------------------------------------------------
//timecardのレコードをフォームにいれる関数
function return_timecard(){
  $("#timecard_date").change(function(){ //日付を変更するとイベントが発火します
    var input_date = $("#timecard_date").val(); // フォームの値を'input_date'という名前の変数に代入します
    var userIdToken = liff.getIDToken(); //LIFFを使用してusersのlineIDトークンを取得
    $.ajax({
      type:'POST',
      url: '/timecard/set_record',//送信先コントローラのpass
      data: {input_date: input_date, user_id_token: userIdToken}, // コントローラへ日付とuserIDトークンの値を非同期で送信
      dataType: 'json'
    })
    .done(function(data){
      if (data.exist == true){
        document.getElementById('timecard_start_time').value = data.start_time;
        document.getElementById("timecard_finish_time").value = data.finish_time;
        document.getElementById("timecard_break_time").value = data.break_time/60;
        document.getElementById("timecardId").value = data.timecard_id;
        $("#timecard_edit_form").attr({"action": '/time_cards/' + data.timecard_id});
        timecard_data = data;
        return timecard_data
      }else{
        $("#timecard_start_time").attr({"value": ""});
        $("#timecard_finish_time").attr({"value": ""});
        $("#timecard_break_time").attr({"value": ""});
        $("#timecardId").attr({"value": ""});
        $("#timecard_edit_form").attr({"action": '/time_cards/'});
        $("#sendMessageBtn").attr({"disabled": "disabled"});
        timecard_data = undefined;
      }
    })
    .fail(function(){
      // 通信に失敗した場合の処理です
      alert('通信に失敗しました') // alertで通信失敗の旨を表示します
    })
  })
}

//日付が入力されているか確認し、状態に応じて他のフォームを選択可能にする関数
function judgeDateFormStatus(){
  $("#timecard_date").change(function(){ //日付を変更するとイベントが発火します
    var date_status = document.getElementById("timecard_date").value !== "";
    if(date_status == true){
      $("#timecard_start_time").removeAttr("disabled");
      $("#timecard_finish_time").removeAttr("disabled");
      $("#timecard_break_time").removeAttr("disabled");
    }else{
      $("#timecard_start_time").attr({"disabled": "disabled"});
      $("#timecard_finish_time").attr({"disabled": "disabled"});
      $("#timecard_break_time").attr({"disabled": "disabled"});
    }
  });
}
//保存されているレコードと内容が一致する場合はsubmitをdisabledに、そうでない場合はableに変更する関数
function changeSubmitBtnStatus(){
  $("#timecard_edit_form").change(function(){
    if (timecard_data !== undefined){
      var start_time_status = document.getElementById('timecard_start_time').value == timecard_data.start_time;
      var finish_time_status = document.getElementById("timecard_finish_time").value == timecard_data.finish_time;
      var break_time_status = document.getElementById("timecard_break_time").value == timecard_data.break_time/60;
      if (start_time_status == false||finish_time_status == false||break_time_status == false ){
        $("#sendMessageButton").removeAttr("disabled");
      }else{
        $("#sendMessageButton").attr({"disabled": "disabled"});
      }
    }else{
      var checkValid=document.getElementById('timecard_edit_form').checkValidity();
      if (checkValid == true){
        $("#sendMessageButton").removeAttr("disabled");
      }else{
        $("#sendMessageButton").attr({"disabled": "disabled"});
      }
    }
  });
}

//勤務終了時刻が勤務開始時刻よりも後であることを確認する関数。falseの場合は送信をキャンセル
function judgeWorktime(){
  document.getElementById("sendMessageButton").addEventListener('click', function(event){
    var start_time = document.getElementById("timecard_start_time").value;
    var finish_time = document.getElementById("timecard_finish_time").value;
    if (start_time<finish_time){
      //htmlでフォームのバリデーションに引っかかったらfalse,問題なければtrueが入る
      var checkValid = document.getElementById('timecard_edit_form').checkValidity();
      //バリデーションが問題なければ送信するかどうかの判断をする
      if (checkValid == true){
        var userIdToken = liff.getIDToken();
        document.getElementById("userIdToken").value = userIdToken;
      }
    }else{
      alert("終了時刻を開始時刻よりも後に設定してください")
      event.preventDefault();
    }
  })
}

