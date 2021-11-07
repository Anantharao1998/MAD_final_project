// ignore_for_file: file_names, prefer_const_constructors, avoid_print, unnecessary_string_interpolations

import 'dart:convert';
import 'package:final_project/PostDetail.dart';
import 'package:final_project/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:favorite_button/favorite_button.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController name = TextEditingController();
  bool isFavorite = false;
  bool favouriteClicked = false;

  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  List posts = [];
  List favoritePosts = [];

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });
      channel.sink.close();
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  sortDate() {
    for (int i = 0; i >= posts.length; i++) {}
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
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider(
                        create: (context) => MainCubit(),
                        child: BlocBuilder<MainCubit, String>(
                          builder: (context, state) {
                            return AlertDialog(
                              title: const Text("Information"),
                              content: Text(
                                  "Tap and hold a post to delete the post"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Ok"),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    });
              },
              icon: Icon(Icons.info),
            ),
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
        body: (favouriteClicked = true)
            ? BlocBuilder<MainCubit, String>(
                builder: (context, index) {
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetails(
                                    name: posts[index]['author'],
                                    title: posts[index]['title'],
                                    description: posts[index]['description'],
                                    url: posts[index]['image'],
                                  ),
                                ),
                              );
                              // Move to post details page
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => MainCubit(),
                                      child: BlocBuilder<MainCubit, String>(
                                        builder: (context, state) {
                                          return AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: Column(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                TextFormField(
                                                  controller: name,
                                                ),
                                                Text(
                                                    "Do you want to delete this post?"),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deletePost(
                                                        '${posts[index]['_id']}',
                                                        name.text);

                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text('Delete'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10.0),
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
                                    '${posts[index]["title"].toString().characters.take(20)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Created by ${posts[index]["author"].toString().characters.take(15)} on ${posts[index]["date"].toString().characters.take(10)}'),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FavoriteButton(
                                          iconSize: 30.0,
                                          valueChanged: (isFavorite) {
                                            setState(() {
                                              isFavorite = true;
                                              if (favoritePosts
                                                  .contains(posts[index])) {
                                                favoritePosts
                                                    .remove(posts[index]);
                                                print('item already added');
                                              } else {
                                                favoritePosts.add(posts[index]);
                                              }
                                              print(favoritePosts);
                                            });
                                          }),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      });
                },
              )
            : Container(
                color: Colors.red,
              ),
      ),
    );
  }

  void deletePost(postID, name) {
    try {
      final channel =
          IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

      channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');

      channel.sink.add('{"type":"delete_post","data":{"postId":"$postID"}}');
    } catch (e) {
      // Catch error if you are not the owner of the post
    }
  }
}
