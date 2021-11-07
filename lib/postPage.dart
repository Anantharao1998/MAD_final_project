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

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });
      channel.sink.close();
      print(posts);
      dispose();
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.white,
                child: Image.network(
                    'https://img.rawpixel.com/s3fs-private/rawpixel_images/website_content/rm222-mind-22_1_2.jpg?w=800&dpr=1&fit=default&crop=default&q=65&vib=3&con=3&usm=15&bg=F4F4F3&ixlib=js-2.2.1&s=3d5d85909cafb6e0f0de9905cf40ec01'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: () {}, child: Text('About Our App')),
                  TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/');
                      },
                      child: Text('Log Out')),
                ],
              )
            ],
          ),
        ),
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
            print(posts.length);
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
                              '${posts[index]["title"].toString().characters.take(10)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                '${posts[index]["description"].toString().characters.take(20)}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Author',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    '${posts[index]["author"].toString().characters.take(10)}'),
                                Text(
                                    '${posts[index]["date"].toString().characters.take(10)}'),
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
