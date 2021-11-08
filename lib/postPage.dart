// ignore_for_file: file_names, prefer_const_constructors, avoid_print, unnecessary_string_interpolations, annotate_overrides, no_logic_in_create_state, unused_local_variable

import 'dart:convert';
import 'package:final_project/PostDetail.dart';
import 'package:final_project/createPost.dart';
import 'package:final_project/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key, required this.channel}) : super(key: key);
  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return _PostPageState(channel);
  }
}

class _PostPageState extends State<PostPage> {
  _PostPageState(this.channel);
  WebSocketChannel channel;
  TextEditingController name = TextEditingController();
  bool isFavorite = false;
  bool favouriteClicked = false;

  List posts = [];
  List favoritePosts = [];

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });
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
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'aboutPage');
                      },
                      child: Text('About Our App')),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (favouriteClicked == true) {
                      favouriteClicked = false;
                    } else {
                      favouriteClicked = true;
                    }
                  });
                },
                icon: Icon(Icons.favorite)),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreatePost(channel: channel)));
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
        body: (favouriteClicked == false)
            ? BlocBuilder<MainCubit, dynamic>(
                builder: (context, index) {
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = posts.length - 1 - index;
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetails(
                                    name: posts[reversedIndex]['author'],
                                    title: posts[reversedIndex]['title'],
                                    description: posts[reversedIndex]
                                        ['description'],
                                    url: posts[reversedIndex]['image'],
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
                                            content: Text(
                                                "Do you want to delete this post?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context
                                                        .read<MainCubit>()
                                                        .delete(
                                                            posts[reversedIndex]
                                                                ['_id'],
                                                            channel);

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
                                                      posts[reversedIndex]
                                                          ['image'])
                                                  .isAbsolute &&
                                              posts[reversedIndex]
                                                  .containsKey('image')
                                          ? '${posts[reversedIndex]['image']}'
                                          : 'https://advertisermirror.com/wp-content/uploads/2021/02/Page-Not-Found-Error-404-329x247.png')),
                                  title: Text(
                                    '${posts[reversedIndex]["title"].toString().characters.take(20)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Created by ${posts[reversedIndex]["author"].toString().characters.take(15)} on ${posts[reversedIndex]["date"].toString().characters.take(10)}'),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FavoriteButton(
                                          iconColor: Colors.blue,
                                          iconSize: 30.0,
                                          valueChanged: (isFavorite) {
                                            setState(() {
                                              isFavorite = true;
                                              if (favoritePosts.contains(
                                                  posts[reversedIndex])) {
                                                favoritePosts.remove(
                                                    posts[reversedIndex]);
                                                print('item already added');
                                              } else {
                                                favoritePosts
                                                    .add(posts[reversedIndex]);
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
            : BlocBuilder<MainCubit, String>(
                builder: (context, state) {
                  return ListView.builder(
                      itemCount: favoritePosts.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = posts.length - 1 - index;

                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetails(
                                    name: posts[reversedIndex]['author'],
                                    title: posts[reversedIndex]['title'],
                                    description: posts[reversedIndex]
                                        ['description'],
                                    url: posts[reversedIndex]['image'],
                                  ),
                                ),
                              );
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
                                            content: Text(
                                                "Do you want to delete this post?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context.read().delete(
                                                        posts[reversedIndex]
                                                            ['_id']);

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
                                                    posts[reversedIndex]
                                                        ['image'])
                                                .isAbsolute &&
                                            posts[reversedIndex]
                                                .containsKey('image')
                                        ? '${posts[reversedIndex]['image']}'
                                        : 'https://image.freepik.com/free-vector/bye-bye-cute-emoji-cartoon-character-yellow-backround_106878-540.jpg'),
                                  ),
                                  title: Text(
                                    '${posts[reversedIndex]["title"].toString().characters.take(20)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Created by ${posts[reversedIndex]["author"].toString().characters.take(15)} on ${posts[reversedIndex]["date"].toString().characters.take(10)}'),
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
