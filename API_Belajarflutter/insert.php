<?php 
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php';

    $nama = $_POST['nama'];
    $unitkerja = $_POST['unitkerja'];
    $foto = $_FILES;

    $imagePath = "img/".$nama."_".$unitkerja.".jpg";
    $imgformattedname = $nama."_".$unitkerja.".jpg";

    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $sql = "INSERT INTO tb_users VALUES('', '$nama', '$unitkerja', '$imgformattedname')";
    
    mysqli_query($db, $sql);
?>

