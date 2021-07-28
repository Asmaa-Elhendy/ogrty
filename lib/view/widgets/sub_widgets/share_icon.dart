import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/fetch_controller.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';

import 'package:flutter/material.dart';

class ShareIcon extends StatelessWidget {
  final String token;
  final Doc myPosts;
  final PostsBloc postBloc;
  ShareIcon({@required this.myPosts, @required this.token, @required this.postBloc});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        child: Icon(
          Icons.share,
          color: Color(0xFF0052D0),
          size: 30,
        ),
        onSelected: (int val) async {
          await EasyLoading.show(status: 'Sharing...');
          await PostsController.sharePosts(token: token, id: myPosts.id);
          await EasyLoading.dismiss();
          if (Urls.errorMessage == 'no') {
            await EasyLoading.showToast('Shared', duration: Duration(seconds: 2));
            // postBloc.add(FetchData(token: token, clearPosts: true));
          } else {
            errorWhileOperation(Urls.errorMessage ?? "Err while deleting", context);
          }
        },
        itemBuilder: (_) => <PopupMenuItem<int>>[
              PopupMenuItem(
                value: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Color(0xFF0052D0),
                    ),
                    Text('Share Now'),
                  ],
                ),
              ),
            ]);
  }
}
