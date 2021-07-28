import 'package:equatable/equatable.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:flutter/material.dart';

abstract class PostsState extends Equatable {
  const PostsState();
}

class PostsInitial extends PostsState {
  @override
  List<Object> get props => [];
}

class PostsLoading extends PostsState {
  final List<Doc> postsModel;
  final bool isFirstFetch;
  PostsLoading({@required this.postsModel, @required this.isFirstFetch});

  @override
  List<Object> get props => [];
}

class PostsLoaded extends PostsState {
  final List<Doc> posts;
  PostsLoaded({@required this.posts});
  @override
  List<Object> get props => [];
}

class PostsErr extends PostsState {
  final String message;
  PostsErr({@required this.message});
  @override
  List<Object> get props => [];
}

class PostsFinished extends PostsState {
  final List<Doc> posts;
  PostsFinished({@required this.posts});
  @override
  List<Object> get props => [];
}
