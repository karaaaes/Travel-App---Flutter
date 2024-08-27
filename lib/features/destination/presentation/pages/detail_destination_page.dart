import 'package:d_method/d_method.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';
import 'package:travel_app/features/destination/presentation/widgets/gallery_photo.dart';

class DetailDestinationPage extends StatefulWidget {
  const DetailDestinationPage({super.key, required this.destination});
  final DestinationEntity destination;

  @override
  State<DetailDestinationPage> createState() => _DetailDestinationPageState();
}

class _DetailDestinationPageState extends State<DetailDestinationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          const SizedBox(height: 15),
          gallery(),
          SizedBox(height: 12),
          shortinfo(),
          SizedBox(height: 24),
          facilities(),
          SizedBox(height: 24),
          description(),
          SizedBox(height: 24),
          reviews(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  reviews() {
    List list = [
      [
        'John Doe',
        'assets/images/avatar/p1.jpg',
        4.9,
        'Best Place',
        '2023-01-02'
      ],
      [
        'Mikael Lunch',
        'assets/images/avatar/p2.jpg',
        5,
        'Unforgettable Times !',
        '2023-01-05'
      ],
      [
        'Dinner Sopi Doe',
        'assets/images/avatar/p3.jpg',
        4.1,
        'Well a Good Place',
        '2023-02-25'
      ],
      [
        'Sisterizer Unknown',
        'assets/images/avatar/p4.jpg',
        2,
        'Need to rework !',
        '2024-04-24'
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...list.map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(e[1]),
                  radius: 15,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            e[0],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          RatingBar.builder(
                            initialRating: e[2].toDouble(),
                            allowHalfRating: true,
                            unratedColor: Colors.grey,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {},
                            itemSize: 15,
                            ignoreGestures: true,
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('d MMM').format(DateTime.parse(e[4])),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(e[3],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),)
                    ],
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          widget.destination.description,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        )
      ],
    );
  }

  gallery() {
    List patternGallery = [
      StaggeredTile.count(3, 3), // Maks Horizontal = 5, Maks Vertikal = 3
      StaggeredTile.count(2,
          1.5), // Horizontal 3+2 = 5, Vertikal 3/2 = 1.5 karena bagian kanan ingin menampilkan 2 foto
      StaggeredTile.count(2, 1.5),
    ];

    return StaggeredGridView.countBuilder(
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      crossAxisCount: 5,
      shrinkWrap: true, // Karena ada penggunaan scrollable didalam list view
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      staggeredTileBuilder: (index) {
        return patternGallery[index %
            patternGallery
                .length]; // Setelah kelipatan 3 berakhir, otomatis data selanjutnya akan mengambil pattern yang pertama
      },
      itemBuilder: (context, index) {
        if (index == 2) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return GalleryPhoto(images: widget.destination.images);
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: itemGalleryImage(2)),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: Text('+ More',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          );
        }
        return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: itemGalleryImage(index));
      },
    );
  }

  shortinfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [location(), const SizedBox(height: 4), category()],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [rate(), const SizedBox(height: 4), rateCount()],
        )
      ],
    );
  }

  Widget facilities() {
    final List<String> facilities;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Facilities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...widget.destination.facilities.map((facility) {
          return Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(children: [
              Icon(
                Icons.radio_button_checked,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                facility,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              )
            ]),
          );
        }).toList(),
      ],
    );
  }

  Widget location() {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          alignment: Alignment.center,
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 17,
          ),
        ),
        SizedBox(width: 4),
        Text(
          widget.destination.location,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        )
      ],
    );
  }

  Widget category() {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          alignment: Alignment.center,
          child: Icon(
            Icons.fiber_manual_record,
            color: Theme.of(context).primaryColor,
            size: 15,
          ),
        ),
        SizedBox(width: 4),
        Text(
          widget.destination.category,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        )
      ],
    );
  }

  Widget rate() {
    return RatingBar.builder(
      initialRating: widget.destination.rate,
      allowHalfRating: true,
      unratedColor: Colors.grey,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (value) {},
      itemSize: 15,
      ignoreGestures: true,
    );
  }

  Widget rateCount() {
    String rate = DMethod.numberAutoDigit(widget.destination.rate);
    String rateCount =
        NumberFormat.compact().format(widget.destination.rateCount);

    return Text(
      rate + ' / ' + rateCount + ' reviews',
      style: TextStyle(
          fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
    );
  }

  Widget itemGalleryImage(int index) {
    return ExtendedImage.network(
      URLs.image(widget.destination.images[index]),
      fit: BoxFit.cover,
      width: 100,
      height: 100,
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
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.destination.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      centerTitle: true,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        margin: EdgeInsets.only(
            left: 20, top: MediaQuery.of(context).padding.top, right: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [BackButton(), Icon(Icons.access_alarm)],
        ),
      ),
    );
  }
}
