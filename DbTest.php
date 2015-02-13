<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
assert_options(ASSERT_ACTIVE, 1);

require_once 'Db.php';
assert(Db::getConnection() != NULL);

