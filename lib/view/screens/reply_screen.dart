import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:ogrety_app/controller/blocs/reply_bloc/replies_controller.dart';
import 'package:ogrety_app/controller/blocs/reply_bloc/replies_cubit.dart';
import 'package:ogrety_app/controller/blocs/reply_bloc/replies_state.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/model/fetch_reply_model.dart';
import 'package:ogrety_app/view/widgets/replies.dart';
import 'dart:io';

class RepliesScreen extends StatelessWidget {
  final String token;
  final int commentId;
  RepliesScreen({@required this.token, @required this.commentId});
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    List<Doc> myReplies = [];
    File _myFile;
    final replyBloc = BlocProvider.of<RepliesCubit>(context);
    replyBloc.fetchReplyBloc(token: token, commentId: commentId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              replyBloc.emptyAll();
              Navigator.pop(context);
            }),
        elevation: 5,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          'Replies',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocListener<RepliesCubit, RepliesState>(
        listener: (context, state) {
          print(state);
        },
        bloc: replyBloc,
        child: BlocBuilder<RepliesCubit, RepliesState>(
          bloc: replyBloc,
          builder: (c, state) {
            if (state is RepliesInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is RepliesFetchingLoading) {
              myReplies = state.fetchReplyModel;
            } else if (state is RepliesFetchingLoaded) {
              myReplies = state.fetchReplyModel;
            }
            if (state is AddReplyState) {
              print('ADD REPLY STATE EMMMIIITTTEEEDDDDD');
              myReplies.add(state.newReply);
            }
            if (state is AddFileState) {
              print('ADD FILE STATE EMITEEEDD');
              _myFile = state.newFile;
            }
            if (state is RemoveFileState) {
              print('Remove FILE STATE EMITEEEDD');
              _myFile = state.newFile;
            }

            if (state is RepliesERR) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
            if (myReplies.isEmpty) {
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
                        "no replies yet",
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
                await replyBloc.fetchReplyBloc(token: token, commentId: commentId);
              },
              child: ListView.builder(
                itemBuilder: (con, i) {
                  return RepliesUI(
                    token: token,
                    repliesDetails: myReplies[i],
                  );
                },
                shrinkWrap: true,
                itemCount: myReplies?.length,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Flexible(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<RepliesCubit, RepliesState>(
                        bloc: replyBloc,
                        builder: (c, state) {
                          if (state is AddFileState) {
                            print('ADD FILE STATE EMITEEEDD');
                            _myFile = state.newFile;
                            return Container(
                              width: 60,
                              height: 90,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(25),
                                  image: DecorationImage(
                                      image: FileImage(_myFile), fit: BoxFit.fill)),
                              child: Center(
                                child: IconButton(
                                  icon: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white, width: 3),
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ))),
                                  onPressed: () {
                                    print('pressed');
                                    print(replyBloc.file == null);
                                    replyBloc.clearImage();
                                  },
                                ),
                              ),
                            );
                          }
                          if (state is RemoveFileState) {
                            print('Remove FILE STATE EMITEEEDD');
                            _myFile = state.newFile;
                            return Offstage();
                          } else {
                            return Offstage();
                          }
                        }),
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
                                if (textEditingController.text.isNotEmpty) {
                                  print(commentId);
                                  Map<String, dynamic> docMap = {
                                    "id": 100,
                                    "kind": "reply",
                                    "author": {
                                      "id": ProfileController.profile.id,
                                      "username": ProfileController.profile.username,
                                      "photo": ProfileController.profile.photo,
                                      "role": ProfileController.profile.role
                                    },
                                    "images": _myFile == null ? [] : [_myFile, 'isFile'],
                                    "content": textEditingController.text,
                                    "isShared": false,
                                    "parents": [commentId],
                                    "flavor": null,
                                    "metadata": {"reactions": 0, "comments": 0},
                                    "createdAt": "${DateTime.now().toUtc()}",
                                    "updatedAt": "${DateTime.now().toUtc()}"
                                  };
                                  File ourFile = _myFile ?? null;
                                  ourFile != null
                                      ? replyBloc.clearImage()
                                      : print('file is null');
                                  Doc doc = Doc.fromJson(docMap);
                                  replyBloc.emitNewState(AddReplyState(newReply: doc));
                                  String content = textEditingController.text;
                                  textEditingController.text = " ";
                                  await RepliesController.addReplyFunc(
                                    token: token,
                                    commentId: commentId,
                                    file: ourFile,
                                    content: content,
                                  );
                                  myReplies.clear();
                                  Urls.errorMessage == 'no'
                                      ? await replyBloc.refreshState(
                                          token: token, commentId: commentId)
                                      : print('err');
                                }
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                            )),
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
                    replyBloc.selectImage(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
