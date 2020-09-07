window.addEventListener('turbolinks:load', judgeUserNewApp);

function judgeUserNewApp(){
  //呼び出したいLIFFアプリをuriから特定
  let userNewLiffPass = "/usernew";
  if (location.pathname == userNewLiffPass){
    initializeUserNewLiff();
  };
}
//LIFFを起動----------------------------------------------------------------------------------
function initializeUserNewLiff() {
  MyLiffId= "1654154094-L2PYjd9P";
  liff
    .init({
      liffId: MyLiffId
    })
    .then(() => {
      judgeSignupForm();
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}

//送信する内容を確認する関数
function judgeSignupForm(){
  $("#signup_form").on('submit', function(event){
    change_submit_btn("pushed");
    var checkFamilyName = check_name_value("familyName");
    var checkFirstName = check_name_value("firstName");
    var checkEmplyeeNumber = check_number_value("employeeNumber");
    if ((checkFamilyName&&checkFirstName&&checkEmplyeeNumber) == true){
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
        change_submit_btn("normal");
        liff.closeWindow();
      })
      return false;
    } else {
      change_submit_btn("normal");
      return false;
    }
  })
}

/*
テキストフォームの値を確認する関数
バリデーションNGの場合はエラーメッセージを表示させ、OKの場合はエラーメッセージ を削除する
引数  formID:チェックするフォームのid
*/
function check_name_value(formID){
  var input = document.getElementById(formID).value;
  if ((/^[ァ-ヶー]+$/.test(input) == false)||input==""){
    $(`#${formID}_error`).text('全角カナで入力して下さい');
    return false
  }else{
    $(`#${formID}_error`).text('');
    return true
  }
}

function check_number_value(){
  var input = Number(document.getElementById("employeeNumber").value);
  if ((/[1-9][0-9]{4}/).test(input) == true){
    $('#employeeNumber_error').text('');
    return true
  }else{
    $('#employeeNumber_error').text('5ケタの半角数字で入力して下さい')
    return false
  }
}

//送信ボタンの見た目をコントロールする
function change_submit_btn(status){
  var submit_btn = document.getElementById("sendMessageButton");
  if( status == "pushed"){
    submit_btn.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
  }else if( status == "normal"){
    submit_btn.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';
  }
}