function check(){
  var a = document.getElementById("memo_name").value;
  if(a==""){
    alert("Memo name を入力してください")
    return false;
  }else if(!a.match(/\S/g)){
    return false;
  }
}
