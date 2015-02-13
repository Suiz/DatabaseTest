<?php
/** Resource for a test. URL: test-{userId}-{quizzId}.
 * Methods:
 * <ul>
 *  <li>POST to create a new test.
 *  </li>
 * </ul>
 *
 */
require_once("HttpResource.php");
require_once("db.php");

class TestResource extends HttpResource {
	/** User id */
	protected $userId;
	protected $quizzId;
	
	/** Initialize $user_id. Send 400 if missing or not a positive integer */
	public function init() {
		if (isset($_GET["userId"]) && isset($_GET["quizzId"])) {
			if (is_numeric($_GET["userId"]) && is_numeric($_GET["quizzId"])) {
				$this->userId = 0 + $_GET["userId"];
				$this->quizzId = 0 + $_GET["quizzId"];
				
				if (!is_int($this->userId) || $this->userId <= 0) {
					$this->exit_error(400, "userIdNotPositiveInteger");
				}
				if (!is_int($this->quizzId) || $this->quizzId <= 0) {
					$this->exit_error(400, "quizzIdNotPositiveInteger");
				}
			}
			else {
				$this->exit_error(400, "userIdorquizzIdNotPositiveInteger");
			}
		}
		else {
			$this->exit_error(400, "userIdandquizzIdRequired");
		}
	}
	
	/** Is the request sent by an admin?
	 * Very basic answer here: only user admin (password admin)
	 * is admin. In realistic cases, we should access the DB.
	 * @return type
	 */
	protected function is_admin() {
		$result = false;
		if (isset($_SERVER["PHP_AUTH_USER"])) {
			$result = $_SERVER["PHP_AUTH_USER"] == "admin"
					&& $_SERVER["PHP_AUTH_PW"] == "admin";
		}
		return $result;
	
	}
	
	protected function do_post() {
		
		if (!$this->is_admin()) {
			$this->exit_error(401, "mustBeAdmin");
		}
		
		if (empty($_GET["userId"]) || empty($_GET["quizzId"])) {
			$this->exit_error(400, "userIdandquizzIdRequired");
		}
		try {
			$db = db::getConnection();
			$sql = "INSERT INTO test (quiz_id, user_id) VALUES (:quizzId, :userId)";
			
			$stmt = $db->prepare($sql);
			
			$stmt->bindValue(":userId", $this->userId);
			$stmt->bindValue(":quizzId", $this->quizzId);
			//$stmt->bindValue(":testId", $last_id);
			
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
					$this->headers[] = "Location: test-$last_insert";
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

TestResource::run();
?>