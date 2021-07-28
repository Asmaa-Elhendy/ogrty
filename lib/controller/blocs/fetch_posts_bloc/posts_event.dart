import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();
}

class FetchData extends PostsEvent {
  final String token;
  final bool clearPosts;
  FetchData({@required this.token, @required this.clearPosts});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RefreshData extends PostsEvent {
  final String token;
  final bool clearPosts;
  RefreshData({@required this.token, @required this.clearPosts});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ErrorWhileFetching extends PostsEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
