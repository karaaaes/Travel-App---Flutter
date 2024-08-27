import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';

class GalleryPhoto extends StatelessWidget {
  const GalleryPhoto({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return Stack(
      children: [
        PhotoViewGallery.builder(
          // Untuk membuat foto view
          itemCount: images.length,
          pageController: pageController,
          scrollPhysics: BouncingScrollPhysics(),
          loadingBuilder: (context, event) {
            return CircleLoading();
          },
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
                imageProvider:
                    ExtendedNetworkImageProvider(URLs.image(images[index])),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: images[index]));
          },
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController, // Controller bisa dibikin diatas
                count: images.length,
                effect: WormEffect(
                    dotColor: Colors.grey[200]!,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotHeight: 10,
                    dotWidth: 10),
              ),
            )),
        Container(
          margin: EdgeInsets.only(top: 15, right: 15),
          child: Align(
            child: CloseButton(),
            alignment: Alignment.topRight,
          ),
        )
      ],
    );
  }
}
