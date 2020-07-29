window.addEventListener('load', function(){
  lineSendMessage();
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
