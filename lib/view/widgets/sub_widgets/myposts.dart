import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_post/reactions_cubit.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_post/reactions_state.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:ogrety_app/view/widgets/sub_widgets/more_vert_icon.dart';
import 'package:ogrety_app/view/widgets/sub_widgets/post_image.dart';
import 'package:ogrety_app/view/widgets/sub_widgets/share_icon.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class MyPosts extends StatelessWidget {
  final Doc myPosts;
  final String token;
  final PostsBloc postBloc;
  final ReactionsCubit reactionBloc;
  final Function showCommentsModal;
  MyPosts(
      {@required this.myPosts,
      @required this.token,
      @required this.postBloc,
      @required this.reactionBloc,
      @required this.showCommentsModal});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: myPosts.isShared ? EdgeInsets.symmetric(vertical: 12) : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: myPosts.isShared
            ? Border.all(color: Colors.black, style: BorderStyle.solid, width: 0.4)
            : Border.all(
                style: BorderStyle.none,
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: NetworkImage(
                          myPosts?.sharedPost?.author?.photo ?? myPosts?.author?.photo),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  myPosts.isShared
                      ? '${myPosts?.sharedPost?.author?.username}\nLocation'
                      : '${myPosts?.author?.username}\nLocation',
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT',
                    fontSize: 16,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(),
                ProfileController.profile.id == myPosts.author.id
                    ? myPosts.isShared
                        ? Offstage()
                        : MoreVertIcon(
                            postBloc: postBloc,
                            token: token,
                            myPosts: myPosts,
                            isShared: myPosts.isShared,
                          )
                    : Offstage(),
              ],
            ),
          ),
          myPosts.isShared
              ? myPosts.sharedPost.images.isEmpty
                  ? Offstage()
                  : ContainerImage(myPosts: myPosts)
              : myPosts.images.isEmpty
                  ? Offstage()
                  : ContainerImage(myPosts: myPosts),
          SizedBox(
            height: 8,
          ),
          myPosts.images.isEmpty
              ? Offstage()
              : myPosts.isShared
                  ? Offstage()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5),
                      child: Row(
                        children: [
                          BlocConsumer<ReactionsCubit, ReactionsState>(
                            bloc: reactionBloc,
                            listener: (context, state) {
                              if (state is AddReaction) {
                                print(state.doc);
                              }
                            },
                            buildWhen: (prevState, currentState) {
                              if (currentState is AddReaction) {
                                return myPosts.id == currentState.doc.id;
                              }

                              if (currentState is RemoveReaction) {
                                return myPosts.id == currentState.doc.id;
                              }

                              return true;
                            },
                            builder: (context, state) {
                              return IconButton(
                                icon: Icon(
                                  myPosts.flavor == null
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: myPosts.flavor == null
                                      ? Color(0xFF0052D0)
                                      : Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  myPosts.flavor == null
                                      ? reactionBloc.addReact(token: token, doc: myPosts)
                                      : reactionBloc.removeReact(
                                          token: token, doc: myPosts);
                                },
                              );
                            },
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          IconButton(
                            onPressed: () {
                              showCommentsModal(context,
                                  token: token, postId: myPosts.id);
                            },
                            icon: Icon(
                              Icons.comment,
                              color: Color(0xFF0052D0),
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          ShareIcon(myPosts: myPosts, token: token, postBloc: postBloc),
                          Spacer(),
                          Column(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Color(0xFF0052D0),
                                size: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${timeago.format(myPosts.createdAt)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0x26000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20, top: 15),
            child: Container(
              width: width,
              child: Center(
                child: Text(
                  myPosts.content == null
                      ? myPosts?.sharedPost?.content == null
                          ? ""
                          : myPosts?.sharedPost?.content
                      : '${myPosts.author.username}:  ${myPosts.content}',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w700,
                    wordSpacing: 2,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
          myPosts.images.isEmpty
              ? myPosts.isShared
                  ? Offstage()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5),
                      child: Row(
                        children: [
                          BlocConsumer<ReactionsCubit, ReactionsState>(
                            bloc: reactionBloc,
                            listener: (context, state) {
                              if (state is AddReaction) {
                                print(state.doc);
                              }
                            },
                            buildWhen: (prevState, currentState) {
                              if (currentState is AddReaction) {
                                return myPosts.id == currentState.doc.id;
                              }

                              if (currentState is RemoveReaction) {
                                return myPosts.id == currentState.doc.id;
                              }

                              return true;
                            },
                            builder: (context, state) {
                              return IconButton(
                                icon: Icon(
                                  myPosts.flavor == null
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: myPosts.flavor == null
                                      ? Color(0xFF0052D0)
                                      : Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  myPosts.flavor == null
                                      ? reactionBloc.addReact(token: token, doc: myPosts)
                                      : reactionBloc.removeReact(
                                          token: token, doc: myPosts);
                                },
                              );
                            },
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          IconButton(
                            onPressed: () {
                              showCommentsModal(context,
                                  token: token, postId: myPosts.id);
                            },
                            icon: Icon(
                              Icons.comment,
                              color: Color(0xFF0052D0),
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          ShareIcon(myPosts: myPosts, token: token, postBloc: postBloc),
                          Spacer(),
                          Column(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Color(0xFF0052D0),
                                size: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${timeago.format(myPosts.createdAt)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0x26000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
              : Offstage(),
        ],
      ),
    );
  }
}
