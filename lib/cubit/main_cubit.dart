// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<String> {
  MainCubit() : super('');
  List posts = [];
  dynamic decodedMessage;

  void login(name, channel) {
    channel.sink.add('{"type": "sign_in", "data": {"name": "$name"}}');
  }

  void delete(_id, channel) {
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$_id"}}');
  }

  void createPost(title, description, url, channel) {
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$url"}}');
  }

  String getName() {
    return state;
  }
}
