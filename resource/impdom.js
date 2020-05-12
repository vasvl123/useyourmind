String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};

function get_tree(root){
  var res = '',
      curr = root,
      child_prop = 'firstChild',
      next_prop = 'nextSibling';
      attr_prop = 'attributes';
  while(curr){
    if (curr.nodeType == 3) {
      var t = $.trim(curr.nodeValue.replaceAll('\n ', '').replaceAll('\n', '')); // срезает пробелы
      //var t = curr.nodeValue.replaceAll('\n ', '').replaceAll('\n', '');
      if (t != '') {
        res += "text" + "\t" + t + "\n";
      }
    } else {
      res += "tagName" + "\t" + curr.nodeName + "\n";
      if (curr[attr_prop]){
        res += "_at" + "\n";
        attrs = curr[attr_prop];
        for(var i = attrs.length - 1; i >= 0; i--){
          res += "attrName" + "\t" + attrs[i].name + "\t" + "attrVal" + "\t" + attrs[i].value + "\n";
        }
        res += "_rt" + "\n"
      }
      if (curr[child_prop]){
        var ch = get_tree(curr[child_prop]);
        if (ch != '') {
          res += '_ch' + "\n" + ch + "_rt" + "\n";
        }
      }
    }
    curr = curr[next_prop];
  }
  return res;
}

function impdom(htmltext){
  var node = $('#impdom')[0];
  node.innerHTML = htmltext;
  //console.log(get_tree(node['firstElementChild']));
  return encodeURIComponent(get_tree(node['firstElementChild']));
}
