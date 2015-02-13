<?php
/** Resource for creating a test. URL: test-{userId}-{quizzId}.
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
}

TestResource::run();
?>