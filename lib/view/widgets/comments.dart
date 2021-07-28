import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_comment/react_comment_cubit.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_comment/react_comment_state.dart';
import 'package:ogrety_app/model/fetch_comments_model.dart';
import 'package:ogrety_app/view/screens/reply_screen.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentUI extends StatelessWidget {
  final String token;
  final Doc commentsDetails;
  CommentUI({@required this.commentsDetails, @required this.token});
  @override
  Widget build(BuildContext context) {
    final reactionsBloc = BlocProvider.of<ReactCommentCubit>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(commentsDetails?.author?.photo),
                  fit: BoxFit.fill,
                ),
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            flex: 7,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0xfff1f1f4),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 20, top: 15, bottom: 25, left: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                commentsDetails.author.username,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF838383),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(
                              flex: 6,
                            ),
                            Text(
                              "${timeAgo.format(commentsDetails.createdAt)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF838383),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            commentsDetails.content.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                commentsDetails.images.isEmpty
                    ? Offstage()
                    : commentsDetails.images.contains('isFile')
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: FileImage(commentsDetails.images.first),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                                  imageUrl: commentsDetails.images.first,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocConsumer<ReactCommentCubit, ReactCommentState>(
                      bloc: reactionsBloc,
                      listener: (context, state) {
                        if (state is AddReaction) {
                          print(state.doc);
                        }
                      },
                      buildWhen: (prevState, currentState) {
                        if (currentState is AddReaction) {
                          return commentsDetails.id == currentState.doc.id;
                        }

                        if (currentState is RemoveReaction) {
                          return commentsDetails.id == currentState.doc.id;
                        }

                        return true;
                      },
                      builder: (context, state) {
                        return TextButton(
                          child: Text(
                            commentsDetails.flavor == null ? "Like" : "Unlike",
                            style: TextStyle(
                                color: Color(0xFF0052D0),
                                fontWeight: commentsDetails.flavor == null
                                    ? FontWeight.w500
                                    : FontWeight.bold),
                          ),
                          onPressed: () {
                            commentsDetails.flavor == null
                                ? reactionsBloc.addReact(
                                    token: token, doc: commentsDetails)
                                : reactionsBloc.removeReact(
                                    token: token, doc: commentsDetails);
                          },
                        );
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => RepliesScreen(
                                      token: token, commentId: commentsDetails.id)));
                          print(commentsDetails.id);
                        },
                        child: Text(
                          'Replies',
                          style: TextStyle(
                              color: Color(0xFF0052D0), fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
