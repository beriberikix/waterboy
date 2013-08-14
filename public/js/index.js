var socket = new WebSocket('ws://' + window.location.hostname + ':3002');
socket.onmessage = function(msg) {
  console.log(msg);
  parseMessageData(msg.data);
};

function parseMessageData(data) {
  var scorePattern = /b([0-9]+)-r([0-9]+)/;
  var obj = JSON.parse(data);
  if (scorePattern.test(data)) {
    // Score update
    var res = scorePattern.exec(data);
    $("#b-score").text(res[1]);
    $("#r-score").text(res[2]);
  } else if (data.indexOf("new-match") >= 0) {
      $(".userpic > img").attr("src","/img/blankuser.png");
      $(".username").text("???");
  }

  // Set player faces
  if (obj.match != null) {
    var match = obj.match;
    if (match.r1_id != null) {
      player = getPlayer(match.r1_id);
      setPlayer("r1", player);
    }
    if (match.r2_id != null) {
      player = getPlayer(match.r2_id);
      setPlayer("r2", player);
    }
    if (match.b1_id != null) {
      player = getPlayer(match.b1_id);
      setPlayer("b1", player);
    }
    if (match.b2_id != null) {
      player = getPlayer(match.b2_id);
      setPlayer("b2", player);
    }
  }
}

function setPlayer(selector, player) {
  var selectString = "#" + selector;
  var nameElement = $(selectString + " > span");
  var imgElement = $(selectString + " > img");

  nameElement.text(player.name);
  imgElement.attr('src', player.image_url);
}

function getPlayer(id) {
  return JSON.parse(
    $.ajax({
        type: "GET",
        url: "/players/" + id,
        async: false,
    }).responseText);
}

$(document).ready(function() {
  $("a.async").click(function(e) {
    e.preventDefault();
    $.get($(this).attr("href"));
  });
});
