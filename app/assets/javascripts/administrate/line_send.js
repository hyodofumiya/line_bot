window.addEventListener('load', function(){
  lineSendMessage();
  controll_index_page();
  change_all_line_send_check();
  change_all_user_line_send_check();
  check_submit();
});

function check_submit(){
  $("#line_send_form_in_index").on('submit',function(){
    var checked_line_send_btn = checked_line_send();
    if (checked_line_send_btn == true){
      var message = exist_line_message();
      var user = more_than_one_user_be_selected();
      if((message == false) && (user == false)){
        alert ('送信先とLINEメッセージを入力してください。');
        return false;
      }else if((message == false) && (user == true)){
        alert ('LINEメッセージを入力してください。');
        return false;
      }else if((message == true) && (user == false)){
        alert ('送信先を1つ以上選択してください。');
        return false;
      }else if ((message == true) && (user == true)){
        return true;
      }
    }else{
      return false
    }
  })
}

function lineSendMessage(){
  $("#line_send").change(function(){
    var line_send = document.getElementById("line_send").checked;
    if(line_send == true){
      $('#line_message').removeAttr("disabled");
      $('#field-unit--line_message').removeClass("hidden_zone");
      $("#field-unit--line_message").addClass("field-unit--required");
      $('#field-unit--line_message').css({"color": "#293f54"});
    }else{
      $('#line_message').attr({"disabled": "disabled"});
      $('#field-unit--line_message').addClass("hidden_zone");
      $("#field-unit--line_message").removeClass("field-unit--required");
      $('#field-unit--line_message').css({"color": "gray"});
    }
  })
}

function checked_line_send(){
  var line_send = document.getElementById("line_send").checked;
  if(line_send != true){
    alert("「メッセージを送信」にチェックを入れてください");
    event.preventDefault();
    return false;
  }else{
    return true;
  }
}

function controll_index_page(){
  $("#line_send").change(function(){
    var line_send = document.getElementById("line_send").checked;
    if(line_send == true){
      $('#line_send__submit').removeAttr("disabled");
      $('#line_send__submit').removeClass("hidden_zone");
      $('.check_of_line_send').css({"visibility": "visible"});
      $('#field-unit--line_send__all').removeClass("hidden_zone");
    }else{
      $('#line_send__submit').attr({"disabled": "disabled"});
      $('#line_send__submit').addClass("hidden_zone");
      $('.check_of_line_send').css({"visibility": "hidden"});
      $('#field-unit--line_send__all').addClass("hidden_zone");
    }
  })
}

function change_all_line_send_check(){
  $('#check_of_line_send__all').change(function(){
    var line_send_all = document.getElementById('check_of_line_send__all').checked;
    if(line_send_all == true ){
      $(".check_of_line_send").prop('checked', true);
    }else{
      $(".check_of_line_send").prop('checked', false);
    }
  })
}

function change_all_user_line_send_check(){
  $("#all_user_line_send").change(function(){
    var change_all_user_line_send = document.getElementById("all_user_line_send").checked;
    if(change_all_user_line_send == true ){
      $(".check_of_line_send").prop('checked', true);
      $(".check_of_line_send").attr({"disabled": "disabled"});
      $("#check_of_line_send__all").attr({"disabled": "disabled"});
      $("#check_of_line_send__all").prop({"checked": true});
    }else{
      $(".check_of_line_send").prop('checked', false);
      $(".check_of_line_send").removeAttr("disabled");
      $("#check_of_line_send__all").removeAttr("disabled");
      $("#check_of_line_send__all").prop({"checked": false});
    }
  })
}

//submitが押下された時に送信先userが１人以上選択されていることを確認するメソッド
function more_than_one_user_be_selected(){
  var controller_and_action = page_info();
  var expect_page_info = ["users#new", "users#edit", "standbies#new", "standbies#edit", "time_cards#new", "time_cards#edit"];

  if(expect_page_info.includes(controller_and_action)){
    return true
  }else{
    var checked_lists = 0 //チェックが入っているレコードの数を入れる変数
    var checkbox_lists = document.getElementsByClassName('check_user_of_line_send');
    for (var i = 0; i < checkbox_lists.length; i++){
      if(checkbox_lists[i].checked == true ){
        checked_lists++;
      }
    }
    var checked_all_user_line_send = document.getElementById("all_user_line_send");
    if(checked_lists >= 1){
      return true;
    }else if((checked_lists == 0) && ((checked_all_user_line_send != null) && (checked_all_user_line_send.checked == true))){
      return true;
    }else{
      return false;
    }  
  }
}

//表示しているページのコントローラーとアクションをcontroller#actionの文字列にして返すメソッド
function page_info(){
  var body = document.querySelector("body");
  var controller = body.dataset.controller;
  var action = body.dataset.action;
  var page_info = `${controller}#${action}`;
  return page_info
}

function exist_line_message(){
  var line_message = document.getElementById("line_message");
  if(line_message.value == ""){
    return false;
  }else{
    return true;
  }
}


$(document).ajaxSuccess(function(event, xhr, setting) {
  if (setting.url == "/admin/line_send"){
    alert('メッセージを送信しました');
    document.line_send_form.reset();
  }
});