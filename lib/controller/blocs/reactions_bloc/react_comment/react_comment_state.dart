import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/fetch_comments_model.dart';

abstract class ReactCommentState extends Equatable {
  const ReactCommentState();
}

class ReactCommentInitial extends ReactCommentState {
  @override
  List<Object> get props => [];
}

class AddReaction extends ReactCommentState {
  final Doc doc;
  AddReaction({@required this.doc});
  @override
  List<Object> get props => [doc];
}

class RemoveReaction extends ReactCommentState {
  final Doc doc;
  RemoveReaction({@required this.doc});
  @override
  List<Object> get props => [doc];
}

class Err extends ReactCommentState {
  final String err;
  Err({@required this.err});
  @override
  List<Object> get props => [err];
}
