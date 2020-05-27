window.addEventListener('turbolinks:load', initializeLiff)

//LIFFを起動----------------------------------------------------------------------------------
function initializeLiff() {
  console.log("test1");
  MyLiffId= "1654154094-1nd8zDod";
  liff
    .init({
      liffId: MyLiffId
    })
    .then(() => {
      //日付が変更されるとuserを確認しtimecardのレコードを返す
      return_timecard()
    })
    .catch((err) => {
      console.log(err.code, err.message)
    });
}
//LIFFの機能------------------------------------------------------------------------------------

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
        $("#timecard_start_time").attr({"value": data.start_time});
        $("#timecard_finish_time").attr({"value": data.finish_time});
        $("#timecard_break_time").attr({"value": data.break_time/60});
      }else{
        $("#timecard_start_time").attr({"value": ""});
        $("#timecard_finish_time").attr({"value": ""});
        $("#timecard_break_time").attr({"value": ""});
      }

      end
      //$('').empty(); //前回のフォーム入力情報が残っている場合はそれを消す
        //$('.meal_list').append(`<li>${meal.name} </li>`);
        //データは配列形式でかえってくるので、forEachで繰り返し処理をします
        //ここではデータの単数の変数名をmealと置いていますが、何でも構いません。
        //ただし、値を取り出す場合は"ここで定義した変数名"."json.jbuilderで定義した〇〇(この例ではname)"で取得します。
    })
    .fail(function(){
      // 通信に失敗した場合の処理です
      //alert('検索に失敗しました') // alertで検索失敗の旨を表示します
    })
  })
}


