<?php 
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php';

    $id = $_POST['id'];
    $foto = $_POST['foto'];

    $sql = "DELETE FROM tb_users WHERE id = $id";
    unlink("img/".$foto);

    mysqli_query($db, $sql);
?>