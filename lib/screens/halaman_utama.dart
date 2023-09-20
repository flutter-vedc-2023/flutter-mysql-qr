import 'package:flutter/material.dart';
import 'package:modul_flutter/screens/qr_screens/displaydata.dart';
import 'package:modul_flutter/screens/qr_screens/generatepage.dart';
import 'package:modul_flutter/screens/qr_screens/scanpage.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Utama',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => DisplayDataPage()));
                  },
                  child: Text('Display Data')),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => ScanPage()));
                  },
                  child: Text('QR Scan')),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => GeneratePage()));
                  },
                  child: Text('QR Generate')),
            ),
          ],
        ),
      ),
    );
  }
}
