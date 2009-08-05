function favorite_category(id, box, token) {
  if(box.checked){
    // Favorite the category
    var url = "/categories/favorite/" + id;
  }else{
    // Un-Favorite the category
    var url = "/categories/unfavorite/" + id;
  }
  new Ajax.Request(url, { asynchronous: true, evalScripts: true, parameters: "authenticity_token=" + token});
}

function delete_log_message(box, id, token){
  row = box.parentNode.parentNode;
  new Ajax.Request("/logentries/destroy/" + id, { asynchronous: true, evalScripts: true, parameters: "authenticity_token=" + token});
  row.parentNode.removeChild(row);
}