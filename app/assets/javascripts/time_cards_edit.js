window.addEventListener('turbolinks:load', judgeTimeCardEditApp);

var timecard_data;

function judgeTimeCardEditApp(){
  //呼び出したいLIFFアプリをuriから特定
  let timecardEditPass = "/timecard/edit";
  if (location.pathname == timecardEditPass){
    initializeTimeCardEditLiff();
  };
}

//LIFFを起動----------------------------------------------------------------------------------
function initializeTimeCardEditLiff() {
  var timecard_data = "";
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
      changeAttendance();
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}
//LIFFの機能------------------------------------------------------------------------------------
//日付フォームが変更されるとAjax通信を実行してtimecardのレコードを取得する関数
function return_timecard(){
  $("#timecard_date").change(function(){
    var input_date = $("#timecard_date").val(); // フォームの値を'input_date'という名前の変数に代入
    if (input_date == ""){
      reset_form();
      $("#timecard_day_off").attr({"disabled": "disabled"});
      changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
      changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
    }else{
      var userIdToken = liff.getIDToken(); //LIFFを使用してusersのlineIDトークンを取得
      $.ajax({
        type:'POST',
        url: '/timecard/set_record',
        data: {input_date: input_date, user_id_token: userIdToken}, // コントローラへ日付とuserIDトークンの値を非同期で送信
        dataType: 'json'
      })
      .done(function(data){
        if(data.user_exist == "true"){
          if (input_date == ""){
            reset_form()
          }else{
            $(".timecard_day_off").removeAttr("disabled");
            if (data.exist == true){ //jsonにTimeCardのレコードが存在していた時、各フォームに取得したデータを埋め込む
              document.getElementById('time_card_workday').setAttribute("checked", "true");
              document.getElementById('time_card_holiday').removeAttribute("checked");
              document.getElementById('timecard_start_time').value = data.start_time;
              document.getElementById("timecard_finish_time").value = data.finish_time;
              document.getElementById("timecard_break_time").value = data.break_time/60|0;
              document.getElementById("timecardId").value = data.timecard_id;
              $("#timecard_edit_form").attr({"action": '/time_cards/' + data.timecard_id});
              timecard_data = data;
              return timecard_data;
            }else{  //jsonにTimeCardレコードが存在しなかった時、勤怠を休日に変更し、その他のフォームの値を空にする
              document.getElementById('time_card_workday').removeAttribute("checked");
              document.getElementById('time_card_holiday').setAttribute("checked", "true");
              document.getElementById('timecard_start_time').value = "";
              document.getElementById("timecard_finish_time").value = "";
              document.getElementById("timecard_break_time").value = "";
              document.getElementById("timecardId").value = "";
              $("#timecard_edit_form").attr({"action": '/time_cards/'});
              timecard_data = undefined;
              changeStatusOfDetailsInTimeCardEditForm("disabled");
              changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
              return timecard_data;
            }
          }
        }else{
          alert('データの取得中にエラーが起こりました。');
          liff.closeWindow(); //LIFFを終了する
        }
      })
      .fail(function(){
        // 通信に失敗した場合の処理です
        alert('通信に失敗しました') // alertで通信失敗の旨を表示します
      })
    }
  })
}

//勤怠状況が変更された時に、残りのフォームを制御する関数
function changeAttendance(){
  $(".timecard_day_off").change(function(){
    var attendance = $('input:radio[name="time_card[day_off]"]:checked').val();
    if (attendance == 1){ //勤怠が出勤日だった場合の処理
      changeStatusOfDetailsInTimeCardEditForm("able");
      changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
      $('#timecard_edit_form_delete').remove();
    }else{  //勤怠が休日だった時の処理
      changeStatusOfDetailsInTimeCardEditForm("disable");
      if (timecard_data == undefined){
        changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
      }else{
        changeStatusOfSubmitbtnInTimeCardEditForm("able");
        $('#timecard_edit_form').prepend('<input type="hidden"  id="timecard_edit_form_delete" name="_method" value="DELETE">');
      } 
    }
  });
}

//保存されているレコードと内容が一致する場合はsubmitをdisabledに、そうでない場合はableに変更する関数
function changeSubmitBtnStatus(){
  $("#timecard_edit_form").change(function(){
    if ($('input:radio[name="time_card[day_off]"]:checked').val() == 1){
      if (timecard_data !== undefined){
        var start_time_status = document.getElementById('timecard_start_time').value == timecard_data.start_time;
        var finish_time_status = document.getElementById("timecard_finish_time").value == timecard_data.finish_time;
        var break_time_status = document.getElementById("timecard_break_time").value == timecard_data.break_time/60;
        if (start_time_status == false||finish_time_status == false||break_time_status == false ){
          changeStatusOfSubmitbtnInTimeCardEditForm("able");
        }else{
          changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
        }
      }else{
        var checkValid=document.getElementById('timecard_edit_form').checkValidity();
        if (checkValid == true){
          changeStatusOfSubmitbtnInTimeCardEditForm("able");
        }else{
          changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
        }
      }
    }
  });
}

//フォームの入力内容に不備がないか確認する関数
function judgeWorktime(){
  $("#timecard_edit_form").on('submit', function(event){
    event.preventDefault();
    var date = document.getElementById("timecard_date").value.replace(/-/g,"/");
    var start_time = document.getElementById("timecard_start_time").value;
    var finish_time = document.getElementById("timecard_finish_time").value;
    
    //勤務開始時刻が終了時刻よりも前か確認
    if (start_time<finish_time){
      var start_date_time = Date.parse(date + " " + start_time);
      var finish_date_time = Date.parse(date + " " + finish_time);
      var working_minites = (finish_date_time - start_date_time)/60/1000;
      var breaking_minites = document.getElementById("timecard_break_time").value;
      
      //勤務時間が休憩時間よりも多いことを確認
      if (working_minites > breaking_minites){
        //htmlでフォームのバリデーションに引っかかったらfalse,問題なければtrueが入る
        var checkValid = document.getElementById('timecard_edit_form').checkValidity();
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
            if(data.user_exist == "true"){
              if(data.result == true){
                alert('勤怠簿を修正しました。');
                reset_form();
                timecard_data = undefined;
              }else{
                alert('勤怠簿を修正できませんでした');
              }
              changeStatusOfDetailsInTimeCardEditForm("disabled");
              changeStatusOfSubmitbtnInTimeCardEditForm("disabled");
            }else{
              alert('勤怠簿の修正に失敗しました。');
              liff.closeWindow(); //LIFFを終了する
            }
          })
        }
        return false;
      }else{
        alert("休憩時間を勤務時間よりも短くしてください")
        return false;
      }
    }else{
      alert("終了時刻を開始時刻よりも後に設定してください")
      return false;
    }
  });
};

function reset_form(){
  $("#timecard_edit_form")[0].reset();
  document.getElementById('time_card_workday').removeAttribute("checked", "true");
  document.getElementById('time_card_holiday').removeAttribute("checked", "true");

}

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

//勤務時間等のフォームのアクティブ状況を一括で切り替える関数
function changeStatusOfDetailsInTimeCardEditForm(status){
  if(status == "able"){
    $("#timecard_start_time").removeAttr("disabled");
    $("#timecard_finish_time").removeAttr("disabled");
    $("#timecard_break_time").removeAttr("disabled");
  }else{
    $("#timecard_start_time").attr({"disabled": "disabled"});
    $("#timecard_finish_time").attr({"disabled": "disabled"});
    $("#timecard_break_time").attr({"disabled": "disabled"});
  }
}

//submitボタンのアクティブ状況を切り替える関数
function changeStatusOfSubmitbtnInTimeCardEditForm(status){
  if(status == "able"){
    
    $("#sendMessageButton").removeAttr("disabled");
  }else{
    $("#sendMessageButton").attr({"disabled": "disabled"});
  }
}