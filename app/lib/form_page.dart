import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _controller = TextEditingController();
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color.fromARGB(255, 23, 42, 66),
      appBar: AppBar(title: Text('Form Input')),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Masukkan Nama Kamu',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 231, 231, 231)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 131, 153, 194)),
                ),
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _output = _controller.text;
                });
              },
              child: Text('Tampilkan'),
            ),

            SizedBox(height: 20),
            Text(
              'Halo, $_output!',
              style: TextStyle(fontSize: 30,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 181, 204, 240),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
