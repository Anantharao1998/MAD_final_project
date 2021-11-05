// ignore_for_file: file_names, prefer_const_constructors, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<CreatePost> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                'Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple.shade800,
                ),
              ),
              TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: 'Post title',
                ),
              ),
              Divider(
                height: 20.0,
              ),
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple.shade800,
                ),
              ),
              TextFormField(
                maxLines: 2,
                controller: description,
                decoration: const InputDecoration(
                  hintText: 'Image description',
                ),
              ),
              Divider(
                height: 20.0,
              ),
              Text(
                'Image URL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple.shade800,
                ),
              ),
              TextFormField(
                controller: image,
                decoration: const InputDecoration(
                  hintText: 'Image URL',
                ),
              ),
              Divider(
                height: 20.0,
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            ElevatedButton(
              onPressed: () {
                _createPost();
              },
              child: Text('Create'),
            ),
          ],
        )
      ]),
    );
  }

  _createPost() {
    final channel =
        IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

// Sending user sign in request
    channel.sink.add(
        '{"type":"create_post","data":{"title":"$title","description":"$description","image":"$image"}}');

// This is the response i got from user
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);

      print(decodedMessage);
    });
  }
}
