import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/fetch_controller.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_event.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_state.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial());
  int page = 1;
  List<Doc> oldPosts = [];
  bool load = false;
  emptyAll() {
    page = 1;
    oldPosts.clear();
    load = false;
  }

  @override
  Stream<PostsState> mapEventToState(
    PostsEvent event,
  ) async* {
    print('bloc called');
    if (event is FetchData) {
      print('fetch data event');
      try {
        if (event.clearPosts) {
          emptyAll();
        }
        if (oldPosts.isEmpty) {
          print('we in first check old is empty');
          yield PostsInitial();
          await PostsController.fetchPosts(token: event.token, page: page);
          if (Urls.errorMessage == 'no') {
            oldPosts.addAll(PostsController.posts.docs);
            yield PostsLoading(postsModel: oldPosts, isFirstFetch: page == 1);
            yield PostsLoaded(posts: oldPosts);
          } else {
            yield PostsErr(message: Urls.errorMessage ?? "Error While getting data");
          }
        } else if (PostsController.posts.hasNextPage) {
          print('check in hasNextPage');
          load = true;
          page = page + 1;
          await PostsController.fetchPosts(token: event.token, page: page);
          if (Urls.errorMessage == 'no') {
            oldPosts.addAll(PostsController.posts.docs);
            load = false;
            yield PostsLoading(postsModel: oldPosts, isFirstFetch: page == 1);
            yield PostsLoaded(posts: oldPosts);
          } else {
            load = false;
            yield PostsErr(message: Urls.errorMessage ?? "Error While getting data");
          }
        } else {
          print('no next page');
          yield PostsFinished(posts: oldPosts);
        }
      } catch (e) {
        yield PostsErr(message: Urls.errorMessage ?? "Error While getting data");
      }
    }

    if (event is RefreshData) {
      print('refresh data event');
      emptyAll();
      await PostsController.fetchPosts(token: event.token, page: page);
      if (Urls.errorMessage == 'no') {
        oldPosts.addAll(PostsController.posts.docs);
        yield PostsLoading(postsModel: oldPosts, isFirstFetch: page == 1);
        yield PostsLoaded(posts: oldPosts);
      } else {
        yield PostsErr(message: Urls.errorMessage ?? "Error While getting data");
      }
    }
  }
}
