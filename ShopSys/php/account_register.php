<?php
/**
 * Created by PhpStorm.
 * User: Liang
 * Date: 2018/8/1
 * Time: 11:02
 */

$name = $_POST['name'];
$password = $_POST['password'];

require('db_config.php');
require('dencrypt.php');


$exist = do_select_sql("select * from user where account_name='$name'");
if ($exist != null) {
    echo ResponseToJson::json(0,"此用户名已经存在，注册失败!",null);
} else {
    $storeInfo = do_insert_sql("insert into user (id, account_name, account_password) values (null,'$name','$password')");
    if ($storeInfo == true) {
        echo ResponseToJson::json(200,"注册成功!",null);
    } else {
        echo ResponseToJson::json(0,"注册失败!",null);
    }
}
