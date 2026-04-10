// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:quiz_game/database/database.dart';

class DatabaseHomePage extends StatefulWidget {
  const DatabaseHomePage({super.key});

  @override
  State<DatabaseHomePage> createState() => _DatabaseHomePageState();
}

class _DatabaseHomePageState extends State<DatabaseHomePage> {
  bool _loading = false;
  String _status = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading) CircularProgressIndicator(),
            SizedBox(height: 10),
            if (_status.isNotEmpty)
              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
            Text(
              _status,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _loading
                  ? null
                  : () async {
                      setState(() {
                        _loading = true;
                        _status = 'Inserting data...';
                      });
                      await insertAllData();
                      setState(() {
                        _loading = false;
                        _status = 'Data inserted successfully!';
                      });
                    },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Insert Data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
