import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:images_picker/images_picker.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_event.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/fetch_controller.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import 'dart:io';

class CreatePost extends StatefulWidget {
  final String token;
  CreatePost({@required this.token});
  @override
  _CreatePostState createState() => new _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<String> res = [];

  handelCameraPhoto(BuildContext context) async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      await openAppSettings();
    }
    Navigator.pop(context);
    List<Media> res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 0.5,
    );
    if (res != null) {
      print(res[0].path);
      setState(() {
        res.forEach((e) {
          this.res.add(e.path);
        });
      });
    }
  }

  handelGalleryPhoto(BuildContext context) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      await openAppSettings();
    }
    Navigator.pop(context);
    List<Media> res = await ImagesPicker.pick(
      count: 10,
      pickType: PickType.image,
      quality: 0.5,
    );
    if (res != null) {
      print(res[0].path);
      setState(() {
        res.forEach((e) {
          this.res.add(e.path);
        });
      });
    }
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

  bool load = false;
  String content;
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
              await PostsController.addPostMethod(
                  token: widget.token, file: this.res, content: content);
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
          'Create post',
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
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              selectImage(context);
                            }),
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
                    hintText: "What do you want to talk about ?",
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
                                          child: Image.file(
                                            File(res[i]),
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
