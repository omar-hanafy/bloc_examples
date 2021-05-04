part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  final List<Post> posts;

  const PostState(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostInitial extends PostState {
  PostInitial(List<Post> posts) : super(posts);

  @override
  String toString() => 'PostInitial { Posts: ${posts.length} }';
}

class PostSuccess extends PostState {
  PostSuccess(List<Post> posts) : super(posts);

  @override
  String toString() => 'PostSuccess { Posts: ${posts.length} }';
}

class PostReachedMax extends PostState {
  PostReachedMax(List<Post> posts) : super(posts);

  @override
  String toString() => 'PostReachedMax { Posts: ${posts.length} }';
}

class PostFailure extends PostState {
  PostFailure() : super([]);

  @override
  String toString() => 'PostFailure}';
}
