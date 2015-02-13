<?php
/** Resource for adding a new test. URL: tests.
 * Methods:
 * <ul>
 *  <li>POST to create a new test.
 *  </li>
 * </ul>
 *
 */
require_once("HttpResource.php");
require_once("db.php");

class TestsResource extends HttpResource {
	protected $userId;
	protected $quizzId;
	
	protected function do_post() {
		
		if (empty($_POST["userId"]) || empty($_POST["quizzId"])) {
			$this->exit_error(400, "userIdandquizzIdRequired");
		}else{
			if (is_numeric($_POST["userId"]) && is_numeric($_POST["quizzId"])) {
				$this->userId = 0 + $_POST["userId"];
				$this->quizzId = 0 + $_POST["quizzId"];
		
				if (!is_int($this->userId) || $this->userId <= 0 || !is_int($this->quizzId) || $this->quizzId <= 0) {
					$this->exit_error(400, "userIdOrquizzIdNotPositiveInteger");
				}
			}
			else {
				$this->exit_error(400, "userIdorquizzIdNotNumeric");
			}
		}
		
		try {
			$db = db::getConnection();
			$sql = "INSERT INTO test (quiz_id, user_id) VALUES (:quizzId, :userId)";
			
			$stmt = $db->prepare($sql);
			
			$stmt->bindValue(":userId", $this->userId);
			$stmt->bindValue(":quizzId", $this->quizzId);
			
			$ok = $stmt->execute();
			if ($ok) {
				$nb = $stmt->rowCount();
				if ($nb == 0) {
					$this->exit_error(404);
				}
				else {
					$last_insert = $db->lastInsertId();
					//die($last_insert);
					$this->statusCode = 204;
					$this->headers[] = "New test created successfully with id: ".$last_insert;
				}
			}
			else {
				$erreur = $stmt->errorInfo();
				$this->exit_error(409, $erreur[1]." : ".$erreur[2]);
			}
		}
		catch (PDOException $e) {
			$this->exit_error(500, $e->getMessage());
		}
	}
}

TestsResource::run();
?>