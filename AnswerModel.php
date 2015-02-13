<?php
// Person id (must be in query string
if (empty($_GET["optionId"])) {
  die("'optionId' parameter is mandatory");
}
$id = $_GET["optionId"];

if (empty($_GET["testId"])) {
  die("'testId' parameter is mandatory");
}
$testId = $_GET["testId"];
// Resource url of the person
$url = "answer-$id-in-$testId";
?>
<html>
  <head>
    <style>
      #message {
        height: 1em;
        background: #EEEEEE;
        border: solid 1px #CCCCCC;
        padding: 4px;
      }
    </style>
    <script src="./script/jquery-1.11.2.min.js"></script>
    <script src="./script/base64.js"></script>
  </head>

  <body>
    <form id="editPerson" action="javascript:" style="diplay: none;">
      <label for="name">Question :</label>
      <input id="name"/>
      <br/>
      <button id="update">Submit</button>
      <button id="reload">Reload</button>
    </form>
    <div id="message">message area</div>

    <script>
      $(document).ready(function () {
        // Get data from server when click on Reload button
        $("#reload").click(function (event) {
          $.ajax({
            // HTTP mthod
            type: "GET",
            url: "<?= $url ?>",
            // return type
            dataType: "json",
            // error processing
            // xhr is the related XMLHttpRequest object
            error: function (xhr, string) {
              var msg = (xhr.status == 404)
                      ? "Question  <?= $id ?> not found"
                      : "Error : " + xhr.status + " " + xhr.statusText;
              $("#message").html(msg);
            },
            // success processing (when 200,201, 204 etc)
            success: function (data) {
              $("#name").val(data.name);
              $("#message").html("Question <?= $id ?> loaded")
            }
          });
        });

        // Trigger the click in order to load the data
        $("#reload").click();

        $("#update").click(function (event) {
          // authenticate
          var auth = "Basic " + Base64.encode("admin:admin");
          $.ajax({
            type: "PUT",
            url: "<?= $url ?>",
            data: {
              name: $("#name").val()
            },
            // Add a auth header before sending the request
            beforeSend: function (xhr) {
              xhr.setRequestHeader("Authorization", auth);
            },
            // Error processing
            error: function (xhr, string) {
              $("#message").html("Error : " + xhr.status
                      + " " + xhr.statusText);
            },
            // Ok processing
            success: function (xml) {
              $("#message").html("Person  <?= $id ?> updated");
            }
          });
        });

        $("#delete").click(function (event) {
          // authenticate
          var auth = "Basic " + Base64.encode("admin:admin");
          $.ajax({
            type: "DELETE",
            url: "<?= $url ?>",
            // Add a auth header before sending the request
            beforeSend: function (xhr) {
              xhr.setRequestHeader("Authorization", auth);
            },
            // Error processing
            error: function (xhr, string) {
              $("#message").html("Error : " + xhr.status + " " + xhr.statusText);
            },
            // Ok processing
            success: function (xml) {
              $("#message").html("Person  <?= $id ?> deleted");
            }
          });
        });
      });

    </script>
  </body>
</html>