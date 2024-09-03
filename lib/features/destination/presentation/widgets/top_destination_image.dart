import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/common/app_route.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';
import 'package:travel_app/features/destination/presentation/widgets/parallax_horizontal_delegate.dart';

class TopDestinationImage extends StatelessWidget {
  TopDestinationImage({super.key, required this.url});
    final String url;
    final imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxHorizontalDelegate(
          scrollable: Scrollable.of(context),
          listItemContext: context,
          backgroundImageKey: imageKey),
      children: [
        ExtendedImage.network(
          url,
          key: imageKey,
          fit: BoxFit.cover,
          width: double.infinity,
          handleLoadingProgress: true,
          loadStateChanged: (state) {
            print('Load state: ${state.extendedImageLoadState}');
            if (state.extendedImageLoadState == LoadState.failed) {
              print('load state error');
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[600],
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.black,
                  ),
                ),
              );
            }
    
            if (state.extendedImageLoadState == LoadState.loading) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[600],
                  child: CircleLoading(),
                ),
              );
            }
    
            return null;
          },
        ),
      ],
    );
  }
}
