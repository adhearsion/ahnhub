$(document).ready(function () {

  $("a.recent_commits").click(function () {
    $(this).parent().siblings(".more_data").toggle(500);
    $(this).text($(this).text() == "hide..." ? "recent commits..." : "hide...");
  });

});
