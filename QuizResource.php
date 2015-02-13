<?php

/** Resource for a person. URL: person-{personId}.
 * idArtiste contains only digits: regexp [0-9]+
 * Methods:
 * <ul>
 *  <li>GET to retrieve. Possible responses:
 *    <ul>
 *      <li>200 json representation {person_id:..., name:...}</li>
 *      <li>400 idNotPositiveInteger</li>
 *      <li>404</li>
 *    </ul>
 *  </li>
 *  <li>PUT to update, with name parameter. Reponses:
 *    <ul>
 *      <li>204 Ok no content</li>
 *      <li>400 idNotPositiveInteger or nameMandatoryAndNotEmpty</li>
 *      <li>401 authorized only to admin/admin</li>
 *      <li>404</li>
 *      <li>409 duplicateName</li>
 *    </ul>
 *  </li>
 *  <li>DELETE to delete the person. Responses:
 *    <ul>
 *      <li>204 Ok no content</li>
 *      <li>400 idNotPositiveInteger or nameMandatoryAndNotEmpty</li>
 *      <li>401 authorized only to admin/admin</li>
 *      <li>404</li>
 *    </ul>
 *  </li>
 * </ul>
 *
 */
require_once("HttpResource.php");
require_once("db.php");

class QuizResource extends HttpResource {

    /** Option id & Test id */
    protected $quizId;

    /** Initialize $id. Send 400 if id missing or not positive integer */
    public function init() {
        if (isset($_GET["quizId"])) {
            if (is_numeric($_GET["quizId"])) {
                $this->quizId = 0 + $_GET["quizId"]; // transformer en numerique
                if (!is_int($this->quizId) || $this->quizId <= 0) {
                    $this->exit_error(400, "quizIdNotPositiveInteger");
                }
            } else {
                $this->exit_error(400, "quizIdNotPositiveInteger");
            }
        } else {
            $this->exit_error(400, "quizIdRequis");
        }
    }

    protected function do_get() {
        try {
            $result = NULL;
            $db = Db::getConnection();
            $sql = "select  quiz_id, user_id, title  
                 from quiz
                 where quiz_id = :quiz_id";
            $stmt = $db->prepare($sql);
            $stmt->bindValue(":quiz_id", $this->quizId);
            $ok = $stmt->execute();
            if ($ok) {
                $result = $stmt->fetch(PDO::FETCH_ASSOC);
                $sql = "
                    select question_id ,question_text from question where question_id in
                    (
                        select question_id from quiz_question where quiz_id=$this->quizId
                    );";
                $stmt1 = $db->prepare($sql);
                $ok = $stmt1->execute();
                $questions = $stmt1->fetchAll(PDO::FETCH_ASSOC);
                $result["questions"] =$questions;
                // Produce utf8 encoded json
                $this->headers[] = "Content-type: text/json; charset=utf-8";
                $this->body = json_encode($result);
            } else {
                $this->exit_error(404);
            }
        } catch (PDOException $e) {
            $this->exit_error(500, $e->getMessage());
        }
    }

}

// Simply run the resource
QuizResource::run();
?>