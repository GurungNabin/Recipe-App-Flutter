import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable{
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoaded extends PostState {
  final List<Map<String, dynamic>> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}