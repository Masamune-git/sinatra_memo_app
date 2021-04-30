function check(){
  var memo_name = document.getElementById("memo_name").value;
  if(memo_name==""){
    alert("Memo name を入力してください")
    return false;
  }else if(!memo_name.match(/\S/g)){
    alert("Memo name を入力してください")
    return false;
  }
}
