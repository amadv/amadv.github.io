function sendSuccess(start_time) {
  "use strict";

  var end_time = window.performance.now();
  var elapsed = parseInt(end_time - start_time, 10);

  $("#status").html("Feedback saved in " + elapsed
                    + "ms (yes, really).  Thanks!");
}

function sendError(data, status, xhr) {
  "use strict";

  $("#status").html("Uh oh.  Wasn't able to save your feedback.  Try again?");
  $("#feedback_text").focus();
}

function sendFeedback(event) {
  "use strict";
  event.preventDefault();

  var feedback = $("#feedback_text").val();

  var url = "Unknown";

  if (window.location.href) {
    url = window.location.href;
  }

  var ref = "Unknown";

  if (document.referrer) {
    ref = document.referrer;
  }

  $("#status").html("Submitting feedback...");

  var start_time = window.performance.now();
  $.ajax({
    type: "POST",
    url: "/api/savefeedback/commit",
    async: false,
    contentType: 'application/json',
    data: JSON.stringify({ feedback: feedback, referrer: ref }),
    error: sendError,
    success: function(xhr, status, error) {
      sendSuccess(start_time);
    }
  });
}

$(document).ready(function() {
  "use strict";

  $("#feedback").on("submit", sendFeedback);
  $("#send").on("click", sendFeedback);

  if (document.referrer) {
    $("#referrer").html(document.referrer);
  }

  $("#feedback").removeClass("hide");
  $("#feedback_text").focus();
});
