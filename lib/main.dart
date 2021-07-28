import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/blocs/comments_bloc/comments_bloc_cubit.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_comment/react_comment_cubit.dart';
import 'package:ogrety_app/controller/blocs/reactions_bloc/react_post/reactions_cubit.dart';
import 'package:ogrety_app/controller/blocs/reply_bloc/replies_cubit.dart';
import 'package:ogrety_app/view/screens/welcome.dart';
import 'controller/blocs/reactions_bloc/react_reply/react_reply_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsBloc>(create: (context) => PostsBloc()),
        BlocProvider<CommentsBlocCubit>.value(value: CommentsBlocCubit()),
        BlocProvider<RepliesCubit>.value(value: RepliesCubit()),
        BlocProvider<ReactionsCubit>.value(value: ReactionsCubit()),
        BlocProvider<ReactCommentCubit>.value(value: ReactCommentCubit()),
        BlocProvider<ReactReplyCubit>.value(value: ReactReplyCubit()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(primaryColor: Color(0xff347CE0)),
        home: Welcome(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
