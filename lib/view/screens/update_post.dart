import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/fetch_controller.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_event.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';

class UpdatePost extends StatefulWidget {
  final String token, content;
  final List photos;
  final int id;
  UpdatePost(
      {@required this.token,
      @required this.photos,
      @required this.content,
      @required this.id});
  @override
  _UpdatePostState createState() => new _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  List res = [];
  bool load = false;
  String content;
  @override
  void initState() {
    res = widget.photos;
    content = widget.content;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    content = null;
    res.clear();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                load = true;
              });
              print(res);
              await PostsController.updateOrDeletePostMethod(
                  token: widget.token,
                  photos: this.res,
                  content: this.content,
                  delete: false,
                  id: widget.id);
              setState(() {
                load = false;
              });
              if (Urls.errorMessage == 'no') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => MyTimeline(
                              token: widget.token,
                            )));
                BlocProvider.of<PostsBloc>(context)
                    .add(FetchData(token: widget.token, clearPosts: true));
              } else {
                errorWhileOperation(Urls.errorMessage, context);
              }
              print(this.res.length);
            },
            child: Text(
              'Post',
              style: TextStyle(
                fontFamily: 'Arial Rounded MT',
                fontSize: 16,
                color: const Color(0xff0052d0),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
        title: Text(
          'Update post',
          style: TextStyle(
            fontFamily: 'Arial Rounded MT',
            fontSize: 24,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.left,
        ),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Arial Rounded MT',
              fontSize: 16,
              color: const Color(0xff0052d0),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          load ? LinearProgressIndicator() : Offstage(),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height * .02, left: width * .03),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(ProfileController.profile.photo),
                          radius: 30),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * .01),
                            child: Text(
                              ProfileController.profile.username,
                              style: TextStyle(
                                fontFamily: 'Arial Rounded MT',
                                fontSize: 24,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: width * .01),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.public,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Text(
                                "Every one can see",
                                style: TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * .03,
                ),
                TextField(
                  maxLines: null,
                  onChanged: (String val) {
                    content = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: TextStyle(
                        color: Colors.grey, fontSize: 22, fontWeight: FontWeight.w700),
                    hintText: widget.content,
                  ),
                ),
                res.isEmpty
                    ? Offstage()
                    : Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          padding: EdgeInsets.all(25.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey, width: 0.6)),
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: res.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                              itemBuilder: (c, i) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(17),
                                          child: Image.network(
                                            res[i],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: IconButton(
                                          icon: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white, width: 3),
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                  child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ))),
                                          onPressed: () {
                                            res.removeAt(i);
                                            print(res);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
