// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Aboutpage extends StatelessWidget {
  const Aboutpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 410,
              alignment: Alignment.center,
              child: Image.network(
                  'https://www.bkacontent.com/wp-content/uploads/2020/06/about-us.jpg'),
            ),
            Text(
              'About Us',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                      '*************************************************************'),
                  Text(
                      '-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-'),
                  Text('  '),
                  Text('Developed by Anantha from Besquare'),
                  Text(
                      'App was developed as a part of Mobile Developement Module.'),
                  Text('LateGram was first developed on 8 November 2021'),
                  Text('App version: v.1.0.2'),
                  Text(
                      'User manual for Lategram will be provided later in future'),
                  Text('  '),
                  Text(
                      '-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-'),
                  Text(
                      '*************************************************************'),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
