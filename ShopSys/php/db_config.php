<?php
/**
 * Created by PhpStorm.
 * User: Liang
 * Date: 2018/7/26
 * Time: 16:32
 */

$mysql_server_name = '127.0.0.1';

$mysql_username = 'root';

$mysql_password = 'wX1314X0';

$mysql_database = 'shopdb';

$conn = mysqli_connect($mysql_server_name, $mysql_username, $mysql_password, $mysql_database);
if (!$conn) {
    die('Could not connect:' . mysqli_error($conn));
}

function do_select_sql($sql_query)
{
    global $conn;
    $result = mysqli_query($conn, $sql_query);


    if (!$result) {
        echoErr(mysqli_error($conn));
    }

    if ($result instanceof mysqli_result && mysqli_num_rows($result) > 0) {
        return $result;
    } else {
        return null;
    }
}

function do_insert_sql($sql_query)
{
    global $conn;

    if (!mysqli_query($conn, $sql_query)) {
        echoErr(mysqli_error($conn));
        return false;
    }
    return true;
}

Class ResponseToJson
{
    public static function json($code, $msg = "", $data = array())
    {
        $result = array(
            'code' => $code,
            'msg' => $msg,
            'data' => $data
        );
        return json_encode($result);
    }
}

function echoErr($err)
{
    echo <<<Error
    <script>
    alert('$err');
</script>
Error;
    exit();
}
