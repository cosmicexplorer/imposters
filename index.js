var obj = {
  "pattern": "mill?enn?ials",
  "replacement": {
    "text": "snake people"
  },
  "strictCaps": true
};

var isValidObj = false;

$('#strict-caps').click(function (e) {
  generate();
});

$('input').keyup(function (e) {
  generate();
});

var correctPassHash = 'eb36c7c90e55930216a57f291bd1a127caf1d387306582e94e36218aa7c75aeef85c3dc02f555b0d8c7556807692768bc894a8621aab607bc41352a2a78ae11f';

var reqTimeout = 3000;

var replacementsUrl = 'https://api.github.com/repos/cosmicexplorer/imposters/contents/replacements.json';

$('#commit').click(function () {
  // highly technical web security stuff, don't bother
  var hash = CryptoJS.SHA3($('#password').val());
  var hexHash = hash.toString(CryptoJS.enc.Hex);
  // if (hexHash == correctPassHash) {
  // if (!isValidObj) {
  //   alert("object is invalid");
  //   return;
  // }
  var getFileXhr = $.ajax({
    url: replacementsUrl,
    dataType: 'json',
    success: function (data) {
      makeCommitFromFile(JSON.parse(atob(data.content)));
    },
    error: function () {
      alert("getting file failed");
    },
    timeout: reqTimeout
  });
  // } else {
  //   alert('Wrong password, bozo');
  //   return;
  // }
});

function makeCommitFromFile(prevContents) {
  var newFileContents = JSON.stringify(prevContents.concat(obj), null, 4);
  var show = function(data){console.log(data);};
  getRefsSha(function(sha){
    getTreeSha(sha, show);
  });
}

var refsUrl = 'https://api.github.com/repos/cosmicexplorer/imposters/git/refs/heads/master';

function getRefsSha(cb) {
  $.ajax({
    url: refsUrl,
    dataType: 'json',
    success: function(data) {
      cb(data.object.sha);
    },
    error: function () {
      alert('git failure');
    },
    timeout: reqTimeout
  });
}

var shaUrl =
    'https://api.github.com/repos/cosmicexplorer/imposters/git/commits/';

$.ajax({
  url: 'pass.json',
  dataType: 'json',
  success: function(data) {
    console.log(data);
    var enc = CryptoJS.AES.encrypt(JSON.stringify(data), "fuckboi");
    console.log(enc.toString());
  }
});

$.ajax({
  url: 'pass.enc',
  dataType: 'text',
  success: function(data) {
    console.log(data.toString());
    var decrypted = CryptoJS.AES.decrypt(atob(data), "fuckboi");
    console.log(decrypted);
    console.log(decrypted.toString());
    console.log(btoa(decrypted.toString()));
  },
  error: function(){
    alert("failure");
  },
  timeout: reqTimeout
});

function getTreeSha(sha, cb) {
  $.ajax({
    url: shaUrl + sha,
    dataType: 'json',
    success: function(data) {
      cb(data.tree.sha);
    },
    error: function() {
      alert('git failure');
    },
    timeout: reqTimeout
  });
}

function generate() {
  if (!testRegex($('#pattern').val())) {
    isValidObj = false;
    alert("Pattern string is not a valid regex");
    return;
  }

  obj.pattern = $('#pattern').val();
  obj.replacement.text = $('#replacement').val();
  obj.strictCaps = $('#strict-caps').is(':checked');

  isValidObj = true;

  $('pre#output').html(JSON.stringify(obj, null, 4));
}

$('pre#output').html(JSON.stringify(obj, null, 4));

function testRegex(str) {
  var isValid;
  try {
    new RegExp(str);
    isValid = true;
  } catch (e) {
    isValid = false;
  }
  return isValid;
}
