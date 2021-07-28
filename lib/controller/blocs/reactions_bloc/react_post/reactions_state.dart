import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/model/posts_model.dart';

abstract class ReactionsState extends Equatable {
  const ReactionsState();
}

class ReactionsInitial extends ReactionsState {
  @override
  List<Object> get props => [];
}

class AddReaction extends ReactionsState {
  final Doc doc;
  AddReaction({@required this.doc});
  @override
  List<Object> get props => [doc];
}

class RemoveReaction extends ReactionsState {
  final Doc doc;
  RemoveReaction({@required this.doc});
  @override
  List<Object> get props => [doc];
}

class Err extends ReactionsState {
  final String err;
  Err({@required this.err});
  @override
  List<Object> get props => [err];
}
