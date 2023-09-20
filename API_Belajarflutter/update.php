<?php 
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php';

    $old_nama = $_POST['old_nama'];
    $old_unitkerja = $_POST['old_unitkerja'];
    $old_foto = $_POST['old_foto'];

    $id = $_POST['id'];
    $nama = $_POST['nama'];
    $unitkerja = $_POST['unitkerja'];
    $foto = $_POST['foto'];

    $imagePath = "img/".$nama."_".$unitkerja.".jpg";
    $imgformattedname = $nama."_".$unitkerja.".jpg";

    unlink("img/".$old_foto);
    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $sql = "UPDATE tb_users SET nama = '$nama', unitkerja = '$unitkerja', foto = '$imgformattedname' WHERE id = $id";
    
    mysqli_query($db, $sql);
?>