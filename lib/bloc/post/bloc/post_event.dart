import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final Map<String, dynamic> post;

  const AddPost(this.post);

  @override
  List<Object> get props => [post];
}

class UpdatePost extends PostEvent {
  final int index;
  final Map<String, dynamic> post; 

  const UpdatePost(this.index, this.post);

  @override
  List<Object> get props => [index, post];
}

class RemovePost extends PostEvent {
  final int index;

  const RemovePost(this.index);

  @override
  List<Object> get props => [index];
}

class TogglePostDone extends PostEvent {
  final int index;
  final bool isDone;

  const TogglePostDone(this.index, this.isDone);

  @override
  List<Object> get props => [index, isDone];
}
