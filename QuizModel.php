<?php
require_once 'Db.php';
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
class QuizModel {
    
    public static function get($quizzId){
        $db = Db::getConnection();
        $sql = "select user_id, title 
                 from quiz
                 where user_id = :quiz_id";
        
        $stmt = $db->prepare($sql);
        $stmt->bindValue(":quiz_id", $quizzId);
        $ok = $stmt->execute();
    if ($ok) {
      return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
}

