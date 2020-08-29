window.addEventListener('load', function(){
  var body = document.querySelector("body");
  var controller = body.dataset.controller;
  var action = body.dataset.action;
  var actions = ["new", "edit"]
  if((controller == "standbies") && (actions.includes(action))){
    check_break_start_status();
    change_break_start_status();
  }
})

function check_break_start_status(){
  debugger
  var status = document.getElementById("standby_on_break").checked
  if(status == false){
    $("#field-unit--break_start").addClass("hidden_zone");

  }
}

function change_break_start_status(){

}