import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

part 'post_event.dart';

part 'post_state.dart';

const _postLimit = 20;

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({required this.httpClient}) : super(PostInitial([]));

  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(
    Stream<PostEvent> events,
    TransitionFunction<PostEvent, PostState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is PostFetched) yield* _mapPostFetchedToState(event);
  }

  Stream<PostState> _mapPostFetchedToState(PostFetched fetch) async* {
    if (state is PostReachedMax) yield state;
    try {
      if (state is PostInitial) {
        final posts = await _fetchPosts();
        yield PostSuccess(posts);
      } else if (state is PostSuccess) {
        final nextPosts = await _fetchPosts(state.posts.length);
        if (nextPosts.isEmpty) {
          yield PostReachedMax(state.posts);
        } else
          yield PostSuccess(List.of(state.posts)..addAll(nextPosts));
      }
    } on Exception {
      yield PostFailure();
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return Post(
          id: json['id'] as int,
          title: json['title'] as String,
          body: json['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
