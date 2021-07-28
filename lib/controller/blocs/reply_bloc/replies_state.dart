import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/fetch_reply_model.dart';
import 'dart:io';

abstract class RepliesState extends Equatable {
  const RepliesState();
}

class RepliesInitial extends RepliesState {
  @override
  List<Object> get props => [];
}

class RepliesFetchingLoading extends RepliesState {
  final List<Doc> fetchReplyModel;
  RepliesFetchingLoading({@required this.fetchReplyModel});
  @override
  List<Object> get props => [fetchReplyModel];
}

class RepliesFetchingLoaded extends RepliesState {
  final List<Doc> fetchReplyModel;
  RepliesFetchingLoaded({@required this.fetchReplyModel});
  @override
  List<Object> get props => [fetchReplyModel];
}

class RepliesERR extends RepliesState {
  final String message;
  RepliesERR({@required this.message});
  @override
  List<Object> get props => [message];
}

class AddReplyState extends RepliesState {
  final Doc newReply;
  AddReplyState({@required this.newReply});
  @override
  List<Object> get props => [newReply];
}

class AddFileState extends RepliesState {
  final File newFile;
  AddFileState({@required this.newFile});
  @override
  List<Object> get props => [newFile];
}

class RemoveFileState extends RepliesState {
  final File newFile;
  RemoveFileState({@required this.newFile});
  @override
  List<Object> get props => [newFile];
}
