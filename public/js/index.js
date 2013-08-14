var socket = new WebSocket('ws://' + window.location.hostname + ':3002');
socket.onmessage = function(msg) {
  console.log(msg);
  parseMessageData(msg.data);
};

function parseMessageData(data) {
  var scorePattern = /b([0-9]+)-r([0-9]+)/;
  if (scorePattern.test(data)) {
    // Score update
    var res = scorePattern.exec(data);
    $("#b-score").text(res[1]);
    $("#r-score").text(res[2]);
  } else if (data.indexOf("uid") >= 0) {
    // Player checking in
    var obj = JSON.parse(data);
    var nameElement;
    var imgElement;

    // Parse, this code sucks I knows
    if (obj.team == "BLUE") {
      if (obj.position == "1") {
        nameElement = $("#bp1 > span");
        imgElement = $("#bp1 > img");
      } else if (obj.position == "2") {
        nameElement = $("#bp2 > span");
        imgElement = $("#bp2 > img");
      }
    } else if (obj.team == "RED") {
      if (obj.position == "1") {
        nameElement = $("#rp1 > span");
        imgElement = $("#rp1 > img");
      } else if (obj.position == "2") {
        nameElement = $("#rp2 > span");
        imgElement = $("#rp2 > img");
      }
    }

    // Set the DOM, sup?
    nameElement.text(obj.name);
    imgElement.attr('src', obj.image_url);
  } else if (data.indexOf("new-match") >= 0) {
      $(".userpic").attr("src","/img/blankuser.png");
      $(".username").text("???");
  }
}

$(document).ready(function() {
  $("a.async").click(function(e) {
    e.preventDefault();
    $.get($(this).attr("href"));
  });
});
