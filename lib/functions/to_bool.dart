bool toBool(String string){
  if(string == "false"){
    return false;
  } else if (string == "true"){
    return true;
  } else {
    throw TypeError();
  }
}