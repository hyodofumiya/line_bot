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
      check_name_value('familyName');
      check_name_value('firstName');
      check_number_value();
      judgeSignupForm();
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
}

/*
テキストフォームの値を確認する関数
バリデーションNGの場合はエラーメッセージを表示させ、OKの場合はエラーメッセージ を削除する
引数  formID:チェックするフォームのid
*/
function check_name_value(formID){
  $(`#${formID}`).on('input', function(){
    var input = document.getElementById(formID).value;
    if ((/^[ァ-ヶー]+$/.test(input) == false)||input==""){
      $(`#${formID}_error`).text('全角カナで入力して下さい');
    }else{
      $(`#${formID}_error`).text('');
    }
  })
}

function check_number_value(){
  $('#employeeNumber').on('input', function(){
    var input = Number(document.getElementById("employeeNumber").value);
    if ((/[1-9][0-9]{4}/).test(input) == true){
      $('#employeeNumber_error').text('');
    }else{
      $('#employeeNumber_error').text('5ケタの半角数字で入力して下さい')
    }
  })
}

//フォームの入力内容に不備がないか確認する関数
function judgeSignupForm(){
  $("#signup_form").on('submit', function(event){
    var checkFamilyName = /^[ァ-ヶー]+$/.test(document.getElementById("familyName").value);
    var checkFirstName = /^[ァ-ヶー]+$/.test(document.getElementById("firstName").value);
    var checkEmplyeeNumber = /[1-9][0-9]{4}/.test(document.getElementById("employeeNumber").value);
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
        liff.closeWindow();
      })
      return false;
    } else {
      if(checkFamilyName == false){
        document.getElementById('familyName_input_zone').style.border = 'solid red';
        $(`#familyName_error`).text('全角カナで入力して下さい');
      }else{
        document.getElementById('familyName_input_zone').style.border = '';
        $(`#familyName_error`).text('');
      }
      if(checkFirstName == false){
        document.getElementById('firstName_input_zone').style.border = 'solid red';
        $(`#firstName_error`).text('全角カナで入力して下さい');
      }else{
        document.getElementById('firstName_input_zone').style.border = '';
        $(`#firstName_error`).text('');
      }
      if(checkEmplyeeNumber == false){
        $('#employeeNumber_error').text('5ケタの半角数字で入力して下さい')
        document.getElementById('employeeNumber_input_zone').style.border = 'solid red';
      }else{
        document.getElementById('employeeNumber_input_zone').style.border = '';
        $('#employeeNumber_error').text('')
      }
      return false;
    }
  })
}