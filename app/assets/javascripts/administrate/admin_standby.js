window.addEventListener('load', function(){
  var body = document.querySelector("body");
  var controller = body.dataset.controller;
  var action = body.dataset.action;
  var actions = ["new", "edit"]
  if((controller == "standbies") && (actions.includes(action))){
    set_default_break_forms();
    change_break_forms();
    check_break_forms();
  }
})

//画面読み込み時にwork_statusフィールドとbreak_sumフィールドを切り替える。デフォルト状態は作業中仕様。
function set_default_break_forms(){
  var work_status_status = check_break_start_status();
  change_break_sum_label(work_status_status);
  change_break_start_status(work_status_status);
}

//休憩中・作業中のチェックボックスが変更されるたび、状況に合わせてform群を切り替える
function change_break_forms(){
  $('input[name="standby[work_status]"]').change(function(){
    var work_status_status = check_break_start_status();
    change_break_start_status(work_status_status);
    change_break_sum_label(work_status_status);
  })
}

//submitが押下されたタイミングでbreak_timeのform群に矛盾がないか確認する
function check_break_forms(){
  $('.form').on("submit", function(){
    var break_status = check_break_start_status();
    if (break_status == true){
      var break_start = document.getElementById("standby_break_start").value;
      if (break_start == ""){
        alert("現在の休憩開始時刻を入力してください。");
        return false;
      }
    }else{
      change_null_break_start();
    }
  })
}

//休憩中フォームの選択状況を返す。休憩中がtrue、作業中はfalse。
function check_break_start_status(){
   var work_status = $('input[name="standby[work_status]"]:checked').val();
   if (work_status == "work"){
     var status = false;
   }else if (work_status == "break"){
     var status = true;
   }else{
     return false
   }
   return status;
}


//break_sumフィールドのラベルを切り替える。trueで休憩中仕様、falseで作業中仕様。
function change_break_sum_label(status){
  var break_sum_label = document.getElementById("field-unit--break_sum").firstElementChild.firstElementChild;
  if ( status == true ){
    break_sum_label.innerHTML = "今回以外の休憩時間"
  }else if (status == false){
    break_sum_label.innerHTML = "休憩時間合計"
  }
}

//break_startフィールドの表示・非表示を切り替える。trueで表示、falseで非表示。
function change_break_start_status(status){
  if (status == true){
    $("#field-unit--break_start").removeClass("hidden_zone");
  }else if (status == false){
    $("#field-unit--break_start").addClass("hidden_zone");
  }
}

//break_sumフィールドの入力値をnullにする
function change_null_break_start(){
  document.getElementById("standby_break_start").value = "";
}
