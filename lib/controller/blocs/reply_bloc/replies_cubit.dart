import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ogrety_app/controller/blocs/reply_bloc/replies_controller.dart';
import 'package:ogrety_app/controller/blocs/reply_bloc/replies_state.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/model/fetch_reply_model.dart';
import 'dart:io';
import '../../urls.dart';

class RepliesCubit extends Cubit<RepliesState> {
  RepliesCubit() : super(RepliesInitial());
  int id;
  List<Doc> oldReplies = [];
  int page = 1;
  bool load = false;
  File file;
  final ImagePicker _picker = ImagePicker();

  emptyAll() {
    oldReplies = [];
    id = null;
    page = 1;
    load = false;
  }

  clearImage() {
    file = null;
    emit(RemoveFileState(newFile: file));
  }

  // clearImageWhileDispose() {
  //   file = null;
  // }

  handelCameraPhoto(BuildContext context) async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      await openAppSettings();
    }
    Navigator.pop(context);
    final pickedFile =
        await _picker.getImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    this.file = pickedFile != null ? File(pickedFile?.path) : null;
    file == null
        ? emit(RemoveFileState(newFile: file))
        : emit(AddFileState(newFile: file));
  }

  handelGalleryPhoto(BuildContext context) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      await openAppSettings();
    }
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(
        source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    this.file = pickedFile != null ? File(pickedFile?.path) : null;
    file == null
        ? emit(RemoveFileState(newFile: file))
        : emit(AddFileState(newFile: file));
  }

  selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Choose from sources'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              handelCameraPhoto(context);
            },
            child: Text('Import from camera'),
          ),
          SimpleDialogOption(
            onPressed: () {
              handelGalleryPhoto(context);
            },
            child: Text('Choose from gallery'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  emitNewState(RepliesState repliesBlocState) {
    emit(repliesBlocState);
  }

  refreshState({@required String token, @required int commentId}) async {
    await RepliesController.fetchRepliesByCommentId(
        token: token, commentId: commentId, page: RepliesController.replies.page);
    if (Urls.errorMessage == 'no') {
      oldReplies.addAll(RepliesController.replies.docs);
      emit(RepliesFetchingLoading(fetchReplyModel: oldReplies));
      emit(RepliesFetchingLoaded(fetchReplyModel: oldReplies));
    } else {
      emit(RepliesERR(message: Urls.errorMessage ?? "Error While getting data"));
      print("id on errs: $id");
    }
  }

  fetchReplyBloc({@required String token, @required int commentId}) async {
    if (id == null) {
      load = true;
      print("id on init: $id");
      emit(RepliesInitial());
      await RepliesController.fetchRepliesByCommentId(
          token: token, commentId: commentId, page: page);
      load = false;

      if (Urls.errorMessage == 'no') {
        id = commentId;
        oldReplies.addAll(RepliesController.replies.docs);
        emit(RepliesFetchingLoading(fetchReplyModel: oldReplies));
        emit(RepliesFetchingLoaded(fetchReplyModel: oldReplies));
        print("id after no errs: $id");
      } else {
        emit(RepliesERR(message: Urls.errorMessage ?? "Error While getting data"));
        print("id on errs: $id");
      }
    } else {
      if (RepliesController.replies.hasNextPage) {
        print("id not equal null: $id");
        load = true;
        page = page + 1;
        await RepliesController.fetchRepliesByCommentId(
            token: token, commentId: commentId, page: page);
        load = false;
        if (Urls.errorMessage == 'no') {
          oldReplies.addAll(RepliesController.replies.docs);
          emit(RepliesFetchingLoading(fetchReplyModel: oldReplies));
          emit(RepliesFetchingLoaded(fetchReplyModel: oldReplies));
          print("id after no errs: $id");
        } else {
          emit(RepliesERR(message: Urls.errorMessage ?? "Error While getting data"));
          print("id on errs: $id");
        }
      } else {
        print("id: $id has no next page");
      }
    }
  }
}
