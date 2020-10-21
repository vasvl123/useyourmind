function iframeh(d) {
  var i, frames;
  frames = document.getElementsByTagName("iframe");
  for (i = 0; i < frames.length; ++i)
  {
    if (frames[i].contentWindow.document === d) {
      var f = document.getElementsByTagName("footer");
      var h = document.getElementsByTagName("nav");
      var fh = f[0].offsetTop - h[0].offsetHeight;
      frames[i].height = fh;
      frames[i].style.display = 'block';
      return fh;
    }
  }
}

function updifrm(oid,p) {
  var ot = oid.slice(0,oid.indexOf('_'));
  document.body.classList.remove("sidebar-lg-show");
  document.body.classList.remove("sidebar-show");
  document.getElementById(ot+"_0").classList.remove("data");
  frames = document.getElementsByTagName("iframe");
  for (i = 0; i < frames.length; ++i) {
    var ft = frames[i].id;
    ft = ft.slice(0,ft.indexOf('_'));
    if (ft == ot) {
      if (frames[i].contentWindow.upd) {
        frames[i].contentWindow.upd(p);
      } else {
        setTimeout(function(){updifrm(oid,p)},500);
      }
    }
  }
}

function nodeprop(p_id, p_fid, p, s, d) {
  var i, frames;
  frames = document.getElementsByTagName("iframe");
  for (i = 0; i < frames.length; ++i)
  {
    if (frames[i].contentWindow.document === d) {
      var ft = frames[i].id;
      ft = ft.slice(0,ft.indexOf('_'));
      q = "nodeid=" + ft + "_" + p_id + "&propid=" + p_fid + "&cmd=nodeprop&show=" + s + "&prop=" + p;
      seq_add(q);
    }
  }
}

function showtip(xpos, ypos, tip) {
  var tt = document.getElementById(datatab+'_0');
  let div = document.createElement('div');
   div.className = "badge badge-dark";
   div.style = 'z-index:1060; position:absolute; display: block; top:'+(ypos+25)+'px; left:'+(xpos+10)+'px;'
   div.innerHTML = tip
   tt.append(div);
  return div;
}
