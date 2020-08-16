window.addEventListener('load', function(){
  lineSendMessage();
  exist_line_message();
  controll_index_page();
  unchecked_line_message();
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
    }else{
      $('#line_send__submit').attr({"disabled": "disabled"});
      $('#line_send__submit').addClass("hidden_zone");
      $('.check_of_line_send').css({"visibility": "hidden"});
    }
  })
}

function unchecked_line_message(){
  var line_send = document.getElementById("line_send").checked;
  if(line_send == true){
    $('#line_message').removeAttr("disabled");
    $('#field-unit--line_message').removeClass("hidden_zone");
    $("#field-unit--line_message").addClass("field-unit--required");
    $('#field-unit--line_message').css({"color": "#293f54"});
    $('#line_send__submit').removeAttr("disabled");
    $('#line_send__submit').removeClass("hidden_zone");
    $('.check_of_line_send').css({"visibility": "visible"});
  }else{
    $('#line_message').attr({"disabled": "disabled"});
    $('#field-unit--line_message').addClass("hidden_zone");
    $("#field-unit--line_message").removeClass("field-unit--required");
    $('#field-unit--line_message').css({"color": "gray"});
    $('#line_send__submit').attr({"disabled": "disabled"});
    $('#line_send__submit').addClass("hidden_zone");
    $('.check_of_line_send').css({"visibility": "hidden"});
  }
}