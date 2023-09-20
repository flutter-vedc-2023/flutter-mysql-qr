// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modul_flutter/components/consts.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class HalamanSatu extends StatefulWidget {
  const HalamanSatu({Key? key}) : super(key: key);

  @override
  _HalamanSatuState createState() => _HalamanSatuState();
}

class _HalamanSatuState extends State<HalamanSatu> {
  List data = [];
  String searchText = "";
  //DEKLARASI TAMPUNG DATA GAMBAR
  File? imageFile;

  @override
  void initState() {
    getData('');
    super.initState();
  }

  Future getData(String search) async {
    var response;
    var uri = Uri.parse('http://$ip/$folder/search.php');
    response = await http.post(uri, body: {
      "search": search,
    });
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  //MENAMBAHKAN DATA BESERTA GAMBAR
  Future addData(String nama, String unitkerja, File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse('http://$ip/$folder/insert.php');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,
        filename: path.basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['nama'] = nama;
    request.fields['unitkerja'] = unitkerja;
    var response = await request.send();

    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Ditambahkan',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future updateData(String id, String nama, String unitkerja) async {
    var response;
    var uri = Uri.parse('http://$ip/$folder/update.php');
    response = await http.post(uri, body: {
      "id": id,
      "nama": nama,
      "unitkerja": unitkerja,
    });
    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Diubah',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future deleteData(String id) async {
    var response;
    var uri = Uri.parse('http://$ip/$folder/delete.php');
    response = await http.post(uri, body: {
      "id": id,
    });
    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Dihapus',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  // UBAH _alertDialogInsert() dari
  // AlertDialog _alertDialogInsert()
  // menjadi
  // StatefulBuilder _alertDialogInsert()

  StatefulBuilder _alertDialogInsert() {
    TextEditingController ctrlNama = TextEditingController();
    TextEditingController ctrlunitkerja = TextEditingController();
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  imageFile = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                addData(ctrlNama.text, ctrlunitkerja.text, imageFile!);
              },
              child: const Text('Tambah'),
            ),
          ],
          title: Text('Tambah Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlNama,
                decoration: const InputDecoration(
                  label: Text('Nama'),
                ),
              ),
              TextField(
                controller: ctrlunitkerja,
                decoration: const InputDecoration(
                  label: Text('Unit Kerja'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Gallery'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              imageFile == null
                  ? Container()
                  : SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  AlertDialog _alertDialogDelete(Map<String, dynamic> data) {
    return AlertDialog(
      title: Text('Delete Data'),
      content: Text('Apakah anda ingin menghapus ${data['nama']}'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            deleteData(data['id']);
            Navigator.of(context).pop();
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }

  AlertDialog _alertDialogUpdate(Map<String, dynamic> data) {
    TextEditingController ctrlNama = TextEditingController();
    TextEditingController ctrlunitkerja = TextEditingController();
    ctrlNama.text = data['nama'];
    ctrlunitkerja.text = data['unitkerja'];
    return AlertDialog(
      title: Text('Update Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ctrlNama,
            decoration: const InputDecoration(
              label: Text('Nama'),
            ),
          ),
          TextField(
            controller: ctrlunitkerja,
            keyboardType: TextInputType.none,
            decoration: const InputDecoration(
              label: Text('Unit Kerja'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            updateData(data['id'], ctrlNama.text, ctrlunitkerja.text);
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return _alertDialogInsert();
                });
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,
          title: AnimatedSearchBar(
            searchDecoration: const InputDecoration(
              hintText: "Search",
              alignLabelWithHint: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            searchStyle: TextStyle(color: Colors.white),
            label: "Search Something Here",
            labelStyle: TextStyle(fontSize: 17, color: Colors.white),
            onChanged: (value) {
              setState(() {
                searchText = value;
                getData(value);
              });
            },
            searchIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            closeIcon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: data[index]['foto'] == null
                    ? const Icon(
                        Icons.account_circle,
                        size: 50,
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        child: Image.network(
                            'http://$ip/$folder/img/${data[index]['foto']}'),
                      ),
                title: Text(data[index]['nama']),
                subtitle: Text('Unit Kerja ${data[index]['unitkerja']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _alertDialogUpdate(data[index]);
                              });
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _alertDialogDelete(data[index]);
                              });
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              );
            }));
  }
}
