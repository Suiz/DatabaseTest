<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


class db {

  /** Give a connection to the quizz DB, in UTF-8 */
  public static function getConnection() {
    // DB configuration
    $db = "quiz";
    $dsn = "mysql:dbname=$db;host=localhost";
    $user = "quiz_user";
    $password = "quiz_password";
    // Get a DB connection with PDO library
    $bdd = new PDO($dsn, $user, $password);
    // Set communication in utf-8
    $bdd->exec("SET character_set_client = 'utf8'");
    return $bdd;
  }
}