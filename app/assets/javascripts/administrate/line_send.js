window.addEventListener('load', function(){
  lineSendMessage();
  exist_line_message();
  controll_index_page();
  change_all_line_send_check();
  change_all_user_line_send_check();
  more_than_one_user_be_selected();
  exist_line_message();
});

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

function exist_line_message(){
  $(".form").on('submit', function(){
    var line_send = document.getElementById("line_send").checked;
    var line_message = document.getElementById("line_message").value;
    if((line_send == true)&& !line_message){
      alert("LINEメッセージを入力してください。");
      event.preventDefault();
      return false;
    }
  })
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
  $("#line_send_form_in_index").on('submit',function(){
    var checked_lists = 0 //チェックが入っているレコードの数を入れる変数
    var checkbox_lists = document.getElementsByClassName('check_user_of_line_send');
    for (var i = 0; i < checkbox_lists.length; i++){
      if(checkbox_lists[i].checked == true ){
        checked_lists++;
      }
    }
    var checked_all_user_line_send = document.getElementById("all_user_line_send").checked;
    if((checked_all_user_line_send != true)&&(checked_lists == 0)){
      alert('送信先を選択してください。');
      return false;
    }
  })
}

function exist_line_message(){
  $("#line_send_form_in_index").on('submit',function(){
    debugger
    var line_message = document.getElementById("line_message").value;
    if(line_message == ""){
      alert("送信メッサージを入力してください。");
      return false;
    }
  })
}