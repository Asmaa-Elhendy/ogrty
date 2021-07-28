import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/fetch_comments_model.dart';

abstract class CommentsBlocState extends Equatable {
  const CommentsBlocState();
}

class CommentsBlocInitial extends CommentsBlocState {
  @override
  List<Object> get props => [];
}

class CommentsFetchingLoading extends CommentsBlocState {
  final List<Doc> fetchCommentModel;
  CommentsFetchingLoading({@required this.fetchCommentModel});
  @override
  List<Object> get props => [fetchCommentModel];
}

class CommentsFetchingLoaded extends CommentsBlocState {
  final List<Doc> fetchCommentModel;
  CommentsFetchingLoaded({@required this.fetchCommentModel});
  @override
  List<Object> get props => [fetchCommentModel];
}

class CommentsERR extends CommentsBlocState {
  final String message;
  CommentsERR({@required this.message});
  @override
  List<Object> get props => [message];
}

class AddCommentState extends CommentsBlocState {
  final Doc newComment;
  AddCommentState({@required this.newComment});
  @override
  List<Object> get props => [newComment];
}

// class AddFileState extends CommentsBlocState {
//   final File file;
//   AddFileState({@required this.file});
//   @override
//   List<Object> get props => [file];
// }
