function send_pwd() {
  var ms = new Date();
  var uid = ms.getTime();
  var unm = $('#'+tab+'_402')[0].value;
  var pwd=$('#'+tab+'_416')[0].value;
  var hpwd = CryptoJS.enc.Base64.stringify(CryptoJS.SHA256(unm+pwd));
  var digest = CryptoJS.enc.Base64.stringify(CryptoJS.SHA256(procid+uid+hpwd));
  postcmd('procid='+procid+'&nodeid='+tab+'_298&cmd=auth&uid='+uid+'&unm='+encodeURIComponent(unm)+'&pwd='+digest);
}

function base64ToArrayBuffer(base64) {
  var binary_string =  window.atob(base64);
  var len = binary_string.length;
  var bytes = new Uint8Array( len );
  for (var i = 0; i < len; i++) {
     bytes[i] = binary_string.charCodeAt(i);
  }
  return bytes;
}

 function vig_e(d,k) {
  var da = base64ToArrayBuffer(d);
  var ka = base64ToArrayBuffer(k);
  var r = '';
  for (var i = 0; i < 32; i++) {
   var j = da[i]+ka[i];
   if (j>255) {j=j-256;}
   r += String.fromCharCode(j);
  }
  return window.btoa(r);
}

function send_reg() {
  var ms = new Date();
  var uid = ms.getTime();

  var unm=$('#'+tab+'_83')[0].value;
  var mail=$('#'+tab+'_96')[0].value;
  var pwd=$('#'+tab+'_131')[0].value;
  var pwd2=$('#'+tab+'_143')[0].value;
  var key=$('#'+tab+'_69')[0].value;

  var hpwd = CryptoJS.enc.Base64.stringify(CryptoJS.SHA256(unm+pwd));
  var digest = CryptoJS.enc.Base64.stringify(CryptoJS.SHA256(procid+uid+hpwd));

  var hpwd2 = CryptoJS.enc.Base64.stringify(CryptoJS.SHA256(unm+pwd2));
  var vpwd = vig_e(hpwd2,key);

  postcmd('procid='+procid+'&nodeid='+tab+'_14&cmd=reg&uid='+uid+'&unm='+encodeURIComponent(unm)+'&mail='+encodeURIComponent(mail)+'&pwd='+digest+'&pwd2='+vpwd);
}
