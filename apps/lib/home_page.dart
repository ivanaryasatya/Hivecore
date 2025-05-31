import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color.fromARGB(255, 23, 42, 66),
      

      appBar: AppBar(title: Text('Beranda'),
        backgroundColor: Color.fromARGB(255, 54, 77, 104),
        ),
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text('Buatannya Ivan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 181, 204, 240),
              ),
            ),
            SizedBox(height: 20),
           
            // tombol dan teks
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: Text('Lihat Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            // tombol dan teks
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/form'),
              child: Text(
                'Lihat Form',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/data_input'),
              child: Text(
                'Input Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
