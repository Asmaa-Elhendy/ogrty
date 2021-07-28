import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ogrety_app/controller/ads_controller.dart';
import 'package:ogrety_app/controller/blocs/comments_bloc/comments_bloc_cubit.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_event.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_state.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_post/reactions_cubit.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_post/reactions_state.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:ogrety_app/view/screens/comment_screen.dart';
import 'package:ogrety_app/view/screens/create_post.dart';
import 'package:ogrety_app/view/widgets/sub_widgets/more_vert_icon.dart';
import 'package:ogrety_app/view/widgets/sub_widgets/myposts.dart';
import 'package:ogrety_app/view/widgets/sub_widgets/share_icon.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class PostsUI extends StatelessWidget {
  final String token;
  PostsUI({
    @required this.token,
  });
  @override
  Widget build(BuildContext context) {
    final reactionsBloc = BlocProvider.of<ReactionsCubit>(context);
    final commentBloc = BlocProvider.of<CommentsBlocCubit>(context);
    showCommentsModal(BuildContext context,
        {@required String token, @required int postId}) async {
      Urls.inComments = true;
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return CommentsScreen(
              token: token,
              postId: postId,
            );
          }).whenComplete(() async {
        commentBloc.emptyAll();
        Urls.inComments = false;
      });
    }

    final width = MediaQuery.of(context).size.width;
    List<Doc> myPosts = [];
    final postBloc = BlocProvider.of<PostsBloc>(context);
    postBloc.add(FetchData(token: token, clearPosts: false));
    return WillPopScope(
      onWillPop: () {
        postBloc.emptyAll();
        return Future<bool>.value(true);
      },
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 35),
              child: GestureDetector(
                onTap: () {
                  ProfileController.profile.username != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => CreatePost(token: token)))
                      : print('null');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xfff0f0f0), width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(9999.0, 9999.0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(9999.0, 9999.0),
                          ),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            placeholder: (context, url) => FittedBox(
                              fit: BoxFit.none,
                              child: Container(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueGrey),
                                ),
                              ),
                            ),
                            imageUrl: ProfileController?.profile?.photo,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: 266,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xfff0f0f0),
                        ),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xff60666c),
                              ),
                              children: [
                                TextSpan(
                                  text: 'W',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'hat do you  want to talk about ?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.image,
                        color: Color(0xFF0052D0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<PostsBloc, PostsState>(
              bloc: postBloc,
              builder: (context, PostsState state) {
                if (state is PostsInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PostsErr) {
                  return Center(child: Text('errorrrrrrrr'));
                }
                bool isFinished = false;
                if (state is PostsLoading) {
                  myPosts = state.postsModel;
                } else if (state is PostsLoaded) {
                  myPosts = state.posts;
                }
                if (state is PostsFinished) {
                  myPosts = state.posts;
                  isFinished = true;
                }
                return SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (con, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xfff0f0f0), width: 3)),
                            child: Container(
                              width: width / 2,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  myPosts[i].isShared
                                      ? Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.purple,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        myPosts[i]
                                                            ?.author
                                                            ?.photo),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.elliptical(
                                                              9999.0, 9999.0)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${myPosts[i].author.username}\nLocation',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Arial Rounded MT',
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Spacer(),
                                              ProfileController.profile.id ==
                                                      myPosts[i].author.id
                                                  ? MoreVertIcon(
                                                      postBloc: postBloc,
                                                      token: token,
                                                      myPosts: myPosts[i],
                                                      isShared:
                                                          myPosts[i].isShared,
                                                    )
                                                  : Offstage(),
                                            ],
                                          ),
                                        )
                                      : Offstage(),
                                  MyPosts(
                                      myPosts: myPosts[i],
                                      token: token,
                                      postBloc: postBloc,
                                      reactionBloc: reactionsBloc,
                                      showCommentsModal: showCommentsModal),
                                  myPosts[i].isShared
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20, top: 12),
                                          child: Row(
                                            children: [
                                              BlocConsumer<ReactionsCubit,
                                                  ReactionsState>(
                                                bloc: reactionsBloc,
                                                listener: (context, state) {
                                                  if (state is AddReaction) {
                                                    print(state.doc);
                                                  }
                                                },
                                                buildWhen:
                                                    (prevState, currentState) {
                                                  if (currentState
                                                      is AddReaction) {
                                                    return myPosts[i].id ==
                                                        currentState.doc.id;
                                                  }

                                                  if (currentState
                                                      is RemoveReaction) {
                                                    return myPosts[i].id ==
                                                        currentState.doc.id;
                                                  }

                                                  return true;
                                                },
                                                builder: (context, state) {
                                                  return IconButton(
                                                    icon: Icon(
                                                      myPosts[i].flavor == null
                                                          ? Icons
                                                              .favorite_border
                                                          : Icons.favorite,
                                                      color: myPosts[i]
                                                                  .flavor ==
                                                              null
                                                          ? Color(0xFF0052D0)
                                                          : Colors.red,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {
                                                      myPosts[i].flavor == null
                                                          ? reactionsBloc
                                                              .addReact(
                                                                  token: token,
                                                                  doc: myPosts[
                                                                      i])
                                                          : reactionsBloc
                                                              .removeReact(
                                                                  token: token,
                                                                  doc: myPosts[
                                                                      i]);
                                                    },
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await showCommentsModal(
                                                      context,
                                                      token: token,
                                                      postId: myPosts[i].id);
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
                                              ShareIcon(
                                                  myPosts: myPosts[i],
                                                  token: token,
                                                  postBloc: postBloc),
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
                                                    '${timeago.format(myPosts[i].createdAt)}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: const Color(
                                                          0x26000000),
                                                      fontWeight:
                                                          FontWeight.w700,
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
                            ),
                          ),
                        ),
                        itemCount: myPosts?.length,
                      ),
                      postBloc.load ? CircularProgressIndicator() : Offstage(),
                      isFinished
                          ? Divider(
                              color: Colors.black,
                              thickness: 0.5,
                              indent: 80,
                              endIndent: 80,
                            )
                          : Offstage(),
                      isFinished ? Text('End of results') : Offstage(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
