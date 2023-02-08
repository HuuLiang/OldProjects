<?php
/**
 * Created by PhpStorm.
 * User: Liang
 * Date: 2018/8/3
 * Time: 16:59
 */

session_start();

require('db_config.php');
require('dencrypt.php');

$type = $_POST['type'];
if ($type=="login") {
    $name = $_POST['name'];
    $password = $_POST['password'];

    $result = do_select_sql("select * from user where account_name='$name' and account_password='$password'");

    if ($result != null) {
        //登录成功
        $userInfo = mysqli_fetch_object($result);
        $account = $userInfo->id."&&".$name."&&".$password;
        $_SESSION['user'] = encryptText($account);
        echo ResponseToJson::json(200,"登录成功",null);
    } else {
        $referer = $_SERVER['HTTP_REFERER'];
        echo ResponseToJson::json(0,"账号密码错误，请重新输入",$referer);
    }
} else if ($type == "logout") {
    if (isset($_SESSION['user'])) {
        @session_unset('user');
        session_destroy();
    }
    echo ResponseToJson::json(200,"退出成功",null);
}
