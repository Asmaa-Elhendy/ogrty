import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ogrety_app/model/posts_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ContainerImage extends StatelessWidget {
  final Doc myPosts;
  ContainerImage({@required this.myPosts});
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: 344,
            height: 235,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: PageView.builder(
                controller: pageController,
                itemCount: myPosts.isShared
                    ? myPosts.sharedPost.images.length
                    : myPosts.images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, ind) => CachedNetworkImage(
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  placeholder: (context, url) => FittedBox(
                    fit: BoxFit.none,
                    child: Container(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                      ),
                    ),
                  ),
                  imageUrl: myPosts.isShared
                      ? myPosts.sharedPost.images[ind]
                      : myPosts.images[ind],
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SmoothPageIndicator(
              controller: pageController, // PageController
              count: myPosts.isShared
                  ? myPosts.sharedPost.images.length
                  : myPosts.images.length,
              effect: WormEffect(), // your preferred effect
              onDotClicked: (index) => pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.easeInBack)),
        ],
      ),
    );
  }
}
