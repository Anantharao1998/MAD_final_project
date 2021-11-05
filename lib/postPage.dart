// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/postdetailspage');
            },
            icon: Icon(Icons.add),
          )
        ],
        title: Center(
          child: Text(
            'LateGram',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Text("This is post page"),
    );
  }
}
