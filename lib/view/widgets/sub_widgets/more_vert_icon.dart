import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/fetch_controller.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_event.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/view/screens/update_post.dart';

class MoreVertIcon extends StatelessWidget {
  final String token;
  final Doc myPosts;
  final PostsBloc postBloc;
  final bool isShared;
  MoreVertIcon(
      {@required this.postBloc,
      @required this.token,
      @required this.myPosts,
      @required this.isShared});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: Icon(
        Icons.more_vert,
        color: Color(0xFF0052D0),
        size: 30,
      ),
      onSelected: (int val) async {
        print(val);
        if (val == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => UpdatePost(
                      token: token,
                      photos: myPosts.images,
                      content: myPosts.content,
                      id: myPosts.id)));
        } else {
          await submitRandomOperation(
              message: "You'll delete your post\nAre you sure ?",
              context: context,
              func1: () async {
                Navigator.pop(context);
                await EasyLoading.show(status: 'Deleting...');
                await PostsController.updateOrDeletePostMethod(
                    token: token, photos: [], content: "", delete: true, id: myPosts.id);
                await EasyLoading.dismiss();
                if (Urls.errorMessage == 'no') {
                  await EasyLoading.showToast('Deleted', duration: Duration(seconds: 2));
                  postBloc.add(FetchData(token: token, clearPosts: true));
                } else {
                  errorWhileOperation(Urls.errorMessage ?? "Err while deleting", context);
                }
              },
              func2: () {
                Navigator.pop(context);
              });
        }
      },
      itemBuilder: (_) => isShared
          ? <PopupMenuItem<int>>[
              PopupMenuItem<int>(
                child: Row(
                  children: [
                    Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    Text('Delete Post'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                value: 1,
              ),
            ]
          : <PopupMenuItem<int>>[
              PopupMenuItem<int>(
                  child: Row(
                    children: [
                      Icon(
                        Icons.update,
                        color: Color(0xFF0052D0),
                      ),
                      Text('Update Post'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  value: 0),
              PopupMenuItem<int>(
                child: Row(
                  children: [
                    Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    Text('Delete Post'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                value: 1,
              ),
            ],
    );
  }
}
