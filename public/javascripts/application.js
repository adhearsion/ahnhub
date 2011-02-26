$(document).ready(function () {

  $("a.more").click(function () {
    $(this).siblings(".more_data").toggle(500);
    $(this).text($(this).text() == "less..." ? "more..." : "less...");
  });

});