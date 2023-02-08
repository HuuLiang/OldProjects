<?php
//ob_start();

require ('./php/db_config.php');
require ('./php/dencrypt.php');

checkSession();

function checkSession() {
    session_start();
    if (isset($_SESSION['user'])) {
        skipUpload();
    } else {
        skipLogin();
    }
}

function skipUpload() {
    print <<<SKIP
    <script>
    window.location.href="./pages/upload.html";
    </script>
SKIP;
}

function skipLogin() {
    print <<<Login
    <script>
    window.location.href="./pages/login.html";
</script>
Login;
}
