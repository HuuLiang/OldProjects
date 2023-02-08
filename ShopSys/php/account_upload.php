<?php
/**
 * Created by PhpStorm.
 * User: Liang
 * Date: 2018/7/31
 * Time: 11:48
 */

session_start();

require ('db_config.php');
require ('dencrypt.php');


$userid = explode("&&",decryptText($_SESSION['user']))[0];
$name=$_POST['name'];
$tel=$_POST['tel'];
$cardid=$_POST['cardid'];
$wx=$_POST['wx'];
$shopid=$_POST['shopid'];
$location=$_POST['location'];

//先保存图片文件获取图片文件的url 然后把图片的url保存到数据库中
require_once 'uploadFile.php';
$upload = new upload('images',"../uploads".'/'.$userid.$name);
$fileResponse = $upload->uploadFile();


if (is_array($fileResponse)) {
    $fileDes = implode("&&",$fileResponse);
    $result=do_insert_sql("insert into user_info (id, name, tel, cardid, wx, shopid, location, imgs) VALUES ($userid,'$name','$tel','$cardid','$wx','$shopid','$location','$fileDes') on duplicate key update name='$name', tel='$tel', cardid='$cardid', wx='$wx', shopid='$shopid', location='$shopid', imgs='$fileDes'");
    if ($result==true) {
        echo ResponseToJson::json(200,"提交成功",null);
    } else {
        echo ResponseToJson::json(0,"错误原因:".mysqli_error($conn),null);
    }
} else {
    echo ResponseToJson::json(0,"错误原因:".$fileResponse,null);
}


