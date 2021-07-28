import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ogrety_app/controller/blocs/comments_bloc/comments_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/fetch_comments_model.dart';
import 'comments_bloc_state.dart';

class CommentsBlocCubit extends Cubit<CommentsBlocState> {
  CommentsBlocCubit() : super(CommentsBlocInitial());
  int id;
  List<Doc> oldComments = [];
  int page = 1;
  bool load = false;

  emptyAll() {
    oldComments = [];
    id = null;
    page = 1;
    load = false;
  }

  emitNewState(CommentsBlocState commentsBlocState) {
    emit(commentsBlocState);
  }

  refreshState({@required String token, @required int postId}) async {
    await CommentsController.fetchCommentsByPostId(
        token: token, postId: postId, page: CommentsController.comments.page);
    if (Urls.errorMessage == 'no') {
      oldComments.addAll(CommentsController.comments.docs);
      emit(CommentsFetchingLoading(fetchCommentModel: oldComments));
      emit(CommentsFetchingLoaded(fetchCommentModel: oldComments));
    } else {
      emit(CommentsERR(
          message: Urls.errorMessage ?? "Error While getting data"));
      print("id on errs: $id");
    }
  }

  fetchCommentBloc({@required String token, @required int postId}) async {
    if (id == null) {
      load = true;
      print("id on init: $id");
      emit(CommentsBlocInitial());
      await CommentsController.fetchCommentsByPostId(
          token: token, postId: postId, page: page);
      load = false;

      if (Urls.errorMessage == 'no') {
        id = postId;
        oldComments.addAll(CommentsController.comments.docs);
        emit(CommentsFetchingLoading(fetchCommentModel: oldComments));
        emit(CommentsFetchingLoaded(fetchCommentModel: oldComments));
        print("id after no errs: $id");
      } else {
        emit(CommentsERR(
            message: Urls.errorMessage ?? "Error While getting data"));
        print("id on errs: $id");
      }
    } else {
      if (CommentsController.comments.hasNextPage) {
        print("id not equal null: $id");
        load = true;
        page = page + 1;
        await CommentsController.fetchCommentsByPostId(
            token: token, postId: postId, page: page);
        load = false;
        if (Urls.errorMessage == 'no') {
          oldComments.addAll(CommentsController.comments.docs);
          emit(CommentsFetchingLoading(fetchCommentModel: oldComments));
          emit(CommentsFetchingLoaded(fetchCommentModel: oldComments));
          print("id after no errs: $id");
        } else {
          emit(CommentsERR(
              message: Urls.errorMessage ?? "Error While getting data"));
          print("id on errs: $id");
        }
      } else {
        print("id: $id has no next page");
      }
    }
  }
}
