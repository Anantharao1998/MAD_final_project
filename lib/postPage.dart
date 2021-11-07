// ignore_for_file: file_names, prefer_const_constructors, avoid_print, unnecessary_string_interpolations

import 'dart:convert';

import 'package:final_project/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  List posts = [];

  List getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });
      channel.sink.close();
      print(posts);
    });

    channel.sink.add('{"type": "get_posts"}');
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createpost');
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
        body: BlocBuilder<MainCubit, String>(
          builder: (context, index) {
            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        // Move to post details page
                      },
                      onLongPress: () {
                        // Delete Posts
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(Uri.parse(
                                              posts[index]['image'])
                                          .isAbsolute &&
                                      posts[index].containsKey('image')
                                  ? '${posts[index]['image']}'
                                  : 'https://image.freepik.com/free-vector/bye-bye-cute-emoji-cartoon-character-yellow-backround_106878-540.jpg'),
                            ),
                            title: Text(
                              '${posts[index]["title"]}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Author',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${posts[index]["author"]}'),
                              ],
                            ),
                          )),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
