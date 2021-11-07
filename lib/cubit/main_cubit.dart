// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

class MainCubit extends Cubit<String> {
  MainCubit() : super('');
  List posts = [];
  String Name = '';
  dynamic decodedMessage;

  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  // void openChannel() {
  //   channel.stream.listen((message) {
  //     decodedMessage = jsonDecode(message);
  //     print(decodedMessage);
  //   });
  // }

  void login(name) {
    // Name = name;
    // emit(name);
    channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
  }

  void getPosts() {
    channel.sink.add('{"type": "get_posts"}');
  }

  void delete(_id) {
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$_id"}}');
  }

  void createPost(name, title, description, url) {
    channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');

    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$url"}}');
  }

  String getName() {
    return state;
  }
}