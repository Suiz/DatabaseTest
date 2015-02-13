<?php
$url = "/quiz/QuizResource.php?quizId=1";
?>
<html>
    <head>
        <script src="../script/jquery-1.11.2.min.js"></script>
    </head>
    <body>
        <div id="content"></div>
        <div id="message"></div>
        <script>
            // processing after page is loaded
            $(document).ready(function () {
                // Make an ajax request
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
                                ? "Quiz  <?= $id ?> not found"
                                : "Error : " + xhr.status + " " + xhr.statusText;
                        $("#message").html(msg);
                    },
                    // success processing (when 200,201, 204 etc)
                    success: function (data) {
                        $("#content").html(data.title));
                        $("#message").html("Quiz <?= $id ?> loaded")
                    }
                });
            });
            });
        </script>
    </body>
</html>



