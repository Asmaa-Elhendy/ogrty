import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/model/fetch_comments_model.dart';
import 'package:ogrety_app/controller/blocs/comments_bloc/comments_bloc_state.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/controller/blocs/comments_bloc/comments_bloc_cubit.dart';
import 'package:ogrety_app/controller/blocs/comments_bloc/comments_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/view/widgets/comments.dart';
import 'dart:io';

class CommentsScreen extends StatefulWidget {
  final String token;
  final int postId;
  CommentsScreen({@required this.token, @required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController textEditingController = TextEditingController();
  double height;
  List<Doc> myComments = [];
  File file;
  final ImagePicker _picker = ImagePicker();

  var commentBloc;
  clearImage() {
    setState(() {
      file = null;
    });
  }

  clearImageWhileDispose() {
    file = null;
  }

  handelCameraPhoto(BuildContext context) async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      await openAppSettings();
    }
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = pickedFile != null ? File(pickedFile?.path) : null;
    });
  }

  handelGalleryPhoto(BuildContext context) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      await openAppSettings();
    }
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(
        source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = pickedFile != null ? File(pickedFile?.path) : null;
    });
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

  @override
  void initState() {
    super.initState();
    commentBloc = BlocProvider.of<CommentsBlocCubit>(context);
    commentBloc.fetchCommentBloc(token: widget.token, postId: widget.postId);
  }

  @override
  void dispose() {
    super.dispose();
    clearImageWhileDispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                commentBloc.emptyAll();
                Navigator.pop(context);
              }),
          elevation: 5,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            'Comments',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            BlocBuilder<CommentsBlocCubit, CommentsBlocState>(
              bloc: commentBloc,
              builder: (c, state) {
                if (state is CommentsBlocInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CommentsFetchingLoading) {
                  myComments = state.fetchCommentModel;
                } else if (state is CommentsFetchingLoaded) {
                  myComments = state.fetchCommentModel;
                }
                if (state is AddCommentState) {
                  myComments.add(state.newComment);
                  print('STATEEEEE EEMMMMETETTETEEEEDDDDDDD');
                }
                // if (state is AddFileState) {
                //   _myFile = state.file;
                //   // myComments.add(state.newComment);
                // }

                if (state is CommentsERR) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
                if (myComments.isEmpty) {
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .15,
                          ),
                          Image.asset("images/message.png"),
                          SizedBox(
                            height: height * .02,
                          ),
                          Text(
                            "no comments yet",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return LazyLoadRefreshIndicator(
                  onRefresh: () async {
                    print('refresh');
                  },
                  onEndOfPage: () async {
                    await commentBloc.fetchCommentBloc(
                        token: widget.token, postId: widget.postId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (con, i) {
                        return CommentUI(
                          token: widget.token,
                          commentsDetails: myComments[i],
                        );
                      },
                      shrinkWrap: true,
                      itemCount: myComments?.length,
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            file == null
                                ? Offstage()
                                : Container(
                                    width: 60,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(25),
                                        image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.fill)),
                                    child: Center(
                                      child: IconButton(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
                                                shape: BoxShape.circle),
                                            child: Center(
                                                child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ))),
                                        onPressed: () {
                                          print('pressed');
                                          print(file == null);
                                          clearImage();
                                        },
                                      ),
                                    ),
                                  ),
                            Container(
                              padding: EdgeInsets.only(left: 6),
                              child: TextField(
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Write a comment",
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (textEditingController
                                          .text.isNotEmpty) {
                                        print(widget.postId);
                                        Map<String, dynamic> docMap = {
                                          "id": 100,
                                          "kind": "comment",
                                          "author": {
                                            "id": ProfileController.profile.id,
                                            "username": ProfileController
                                                .profile.username,
                                            "photo":
                                                ProfileController.profile.photo,
                                            "role":
                                                ProfileController.profile.role
                                          },
                                          "images": this.file == null
                                              ? []
                                              : [this.file, 'isFile'],
                                          "content": textEditingController.text,
                                          "isShared": false,
                                          "parents": [widget.postId],
                                          "flavor": null,
                                          "metadata": {
                                            "reactions": 0,
                                            "comments": 0
                                          },
                                          "createdAt":
                                              "${DateTime.now().toUtc()}",
                                          "updatedAt":
                                              "${DateTime.now().toUtc()}"
                                        };
                                        Doc doc = Doc.fromJson(docMap);
                                        commentBloc.emitNewState(
                                            AddCommentState(newComment: doc));
                                        File ourFile = this.file ?? null;
                                        this.file != null
                                            ? clearImage()
                                            : print('file is null');
                                        String content =
                                            textEditingController.text;
                                        textEditingController.text = " ";
                                        await CommentsController.addComment(
                                          token: widget.token,
                                          postId: widget.postId,
                                          file: ourFile,
                                          content: content,
                                        );
                                        myComments.clear();
                                        Urls.errorMessage == 'no'
                                            ? await commentBloc.refreshState(
                                                token: widget.token,
                                                postId: widget.postId)
                                            : print('err');
                                      }
                                    },
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xfff0f0f0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            selectImage(context);
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
