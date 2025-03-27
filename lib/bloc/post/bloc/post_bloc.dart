import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<AddPost>(_onAddPost);
    on<UpdatePost>(_onUpdatePost);
    on<RemovePost>(_onRemovePost);
    on<TogglePostDone>(_onTogglePostDone);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    print('Loading posts...');
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString('posts');
    if (postsJson != null) {
      final posts = List<Map<String, dynamic>>.from(jsonDecode(postsJson));
      emit(PostLoaded(posts));
      print('Loaded posts: $posts');
    } else {
      emit(const PostLoaded([]));
      print('No posts found.');
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final updatedPosts = List<Map<String, dynamic>>.from(currentState.posts)
        ..add(event.post);
      await _savePosts(updatedPosts);
      emit(PostLoaded(updatedPosts));
      print('Updated posts: $updatedPosts');
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final updatedPosts = List<Map<String, dynamic>>.from(currentState.posts);
      updatedPosts[event.index] = event.post;
      await _savePosts(updatedPosts);
      emit(PostLoaded(updatedPosts));
    }
  }

  Future<void> _onRemovePost(RemovePost event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final updatedPosts = List<Map<String, dynamic>>.from(currentState.posts)
        ..removeAt(event.index);
      await _savePosts(updatedPosts);
      emit(PostLoaded(updatedPosts));
    }
  }

  Future<void> _onTogglePostDone(
      TogglePostDone event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final updatedPosts = List<Map<String, dynamic>>.from(currentState.posts);
      updatedPosts[event.index]['isDone'] = event.isDone;
      await _savePosts(
          updatedPosts); // Save the updated posts to SharedPreferences
      emit(PostLoaded(updatedPosts)); // Emit the updated state
      print('Toggled post at index ${event.index} to ${event.isDone}');
    }
  }

  Future<void> _savePosts(List<Map<String, dynamic>> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = jsonEncode(posts);
    await prefs.setString('posts', postsJson);
  }
}
