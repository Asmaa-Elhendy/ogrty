import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:ogrety_app/controller/ads_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/database/local.dart';
import 'package:ogrety_app/view/screens/booking/get_ready.dart';
import 'package:ogrety_app/view/screens/payment.dart';
import 'package:ogrety_app/view/screens/trackMe.dart';
import 'package:ogrety_app/view/screens/transfer.dart';
import 'package:ogrety_app/view/screens/welcome2.dart';
import 'package:ogrety_app/view/widgets/posts.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_bloc.dart';
import 'package:ogrety_app/controller/blocs/fetch_posts_bloc/posts_event.dart';
import 'package:get/get.dart';

class MyTimeline extends StatefulWidget {
  final String token;
  MyTimeline({@required this.token});
  @override
  _MyTimelineState createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline>
    with SingleTickerProviderStateMixin/*<-- This is for the controllers*/ {
  TabController _tabController; // To control switching tabs
  ScrollController _scrollViewController; // To control scrolling
  List<String> items = [];
  Timer timer;
  int i = 0;
  Future reloadAds(String token) async {
    timer = Timer.periodic(Duration(seconds: 3), (time) async {
      i++;
      if (_tabController?.index != 0) {
        print('out timer');
      } else if (Urls.inComments) {
        print('in comments');
      } else if (i % 2 == 0) {
        print('in timer');
        await AdsController.getRandomAdd(token);
        setState(() {});
      } else {
        print('not cancel but number divided on two dose not reminder 0');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 4,
    );
    _scrollViewController = ScrollController();
    reloadAds(widget.token);
  }

  @override
  void dispose() {
    super.dispose();
    print('must dispose');
    _tabController.dispose();
    _scrollViewController.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Init the items
    for (var i = 0; i < 100; i++) {
      items.add('Item $i');
    }

    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: 115,
            toolbarHeight: 35,
            forceElevated: boxIsScrolled,
            actions: [
              Container(
                width: 35,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xfff3f2f7),
                ),
                child: Center(
                    child: IconButton(
                  icon: Icon(
                    Icons.car_repair,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (C) => TrackMe(token: widget.token)));
                  },
                  color: Color(0xFF0052D0),
                )),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 35,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xfff3f2f7),
                ),
                child: Center(
                    child: IconButton(
                        onPressed: () {
                          DataInLocal.saveInLocal(token: '0');
                          Get.offAll(Welcome2());
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Color(0xFF0052D0),
                        ))),
              ),
              SizedBox(
                width: 10,
              ),
            ],
            title: Text(
              'Community',
              style: TextStyle(
                fontSize: 30,
                color: const Color(0xff0052d0),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            floating: true,
            pinned: true,
            snap: true,
            bottom: TabBar(
              indicatorColor: Color(0xFF0052D0),
              onTap: (int val) {
                print(val);
                if (val == 0) {
                  BlocProvider.of<PostsBloc>(context)
                      .add(RefreshData(token: widget.token, clearPosts: false));
                }
              },
              tabs: <Widget>[
                Tab(
                  icon: Container(
                    width: 35,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xfff3f2f7),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.home,
                      color: Color(0xFF0052D0),
                    )),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 35,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xfff3f2f7),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.payment,
                      color: Color(0xFF0052D0),
                    )),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 35,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xfff3f2f7),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.bus_alert,
                      color: Color(0xFF0052D0),
                    )),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 35,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xfff3f2f7),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.money,
                      color: Color(0xFF0052D0),
                    )),
                  ),
                ),
              ],
              controller: _tabController,
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Stack(
            children: [
              LazyLoadRefreshIndicator(
                onRefresh: () async {
                  print('ref');
                  BlocProvider.of<PostsBloc>(context)
                      .add(FetchData(token: widget.token, clearPosts: true));
                  setState(() {});
                },
                onEndOfPage: () {
                  print('end');
                  BlocProvider.of<PostsBloc>(context)
                      .add(FetchData(token: widget.token, clearPosts: false));
                },
                child: PostsUI(
                  token: widget.token,
                ),
              ),
              AdsController.adsModel.id == null
                  ? Offstage()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.black26,
                        child: Image.network(
                          AdsController.adsModel.photo,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ],
          ),
          WayToPayment(token: widget.token),
          GetReady(token: widget.token),
          Transfer(token: widget.token),
        ],
      ),
    );
  }
}
