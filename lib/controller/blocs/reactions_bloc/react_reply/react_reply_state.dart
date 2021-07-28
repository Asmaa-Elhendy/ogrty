import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/fetch_reply_model.dart';

abstract class ReactReplyState extends Equatable {
  const ReactReplyState();
}

class ReactReplyInitial extends ReactReplyState {
  @override
  List<Object> get props => [];
}

class AddReaction extends ReactReplyState {
  final Doc doc;
  AddReaction({@required this.doc});
  @override
  List<Object> get props => [doc];
}

class RemoveReaction extends ReactReplyState {
  final Doc doc;
  RemoveReaction({@required this.doc});
  @override
  List<Object> get props => [doc];
}

class Err extends ReactReplyState {
  final String err;
  Err({@required this.err});
  @override
  List<Object> get props => [err];
}
