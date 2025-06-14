import 'package:flutter/material.dart';

class DataInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 42, 66),
      appBar: AppBar(
        title: const Text('Data Input Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Color.fromARGB(255, 255, 255, 255),
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 231, 231, 231)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 131, 153, 194)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Color.fromARGB(255, 255, 255, 255),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 231, 231, 231)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 131, 153, 194)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Color.fromARGB(255, 255, 255, 255),
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 231, 231, 231)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 131, 153, 194)),
                )
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {

                // Handle form submission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form Submitted')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DataInputPage(),
  ));
}

