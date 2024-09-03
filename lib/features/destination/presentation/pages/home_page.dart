import 'package:d_method/d_method.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/common/app_route.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/bloc/top_destination/top_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/pages/dashboard.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';
import 'package:travel_app/features/destination/presentation/widgets/parallax_horizontal_delegate.dart';
import 'package:travel_app/features/destination/presentation/widgets/text_failure.dart';
import 'package:travel_app/features/destination/presentation/widgets/top_destination_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final topDestinationController = PageController();
  refresh() {
    context.read<TopDestinationBloc>().add(GetTopDestinationEvent());
    context.read<AllDestinationBloc>().add(GetAllDestinationEvent());
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => refresh(),
      child: ListView(
        children: [
          SizedBox(height: 30),
          header(),
          SizedBox(height: 20),
          search(),
          SizedBox(height: 24),
          categories(),
          SizedBox(height: 20),
          topdestination(),
          SizedBox(height: 30),
          allDestination(),
        ],
      ),
    );
  }

  header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor)),
            padding: EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/avatar/profile.png'),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text('Hi, King Raka 👑',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5) // Theme.of(context).textTheme.labelLarge,

              ),
          const Spacer(),
          const SizedBox(width: 3),
          Badge(
              //Ini untuk memberikan element notifications
              backgroundColor: Colors.red,
              alignment: Alignment(1, -0.6),
              child: Icon(Icons.notifications_none)),
        ],
      ),
    );
  }

  search() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.only(left: 24),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search destination here...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.all(0)),
          )),
          SizedBox(width: 10),
          IconButton.filledTonal(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.searchDestination);
              },
              icon: Icon(
                Icons.search,
                size: 24,
              ))
        ],
      ),
    );
  }

  categories() {
    List list = ['Beach', 'Lake', 'Mountain', 'Forest', 'City'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(list.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
                left: index == 0 ? 30 : 10,
                right: index == list.length - 1 ? 30 : 10,
                bottom: 10,
                top: 4),
            child: Material(
              elevation: 4,
              color: Colors.white,
              shadowColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  list[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  topdestination() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Destination',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              BlocBuilder<TopDestinationBloc, TopDestinationState>(
                builder: (context, state) {
                  // print("Current State: $state");
                  if (state is TopDestinationLoaded) {
                    return SmoothPageIndicator(
                      controller:
                          topDestinationController, // Controller bisa dibikin diatas
                      count: state.data.length,
                      effect: WormEffect(
                          dotColor: Colors.grey[200]!,
                          activeDotColor: Theme.of(context).primaryColor,
                          dotHeight: 10,
                          dotWidth: 10),
                    );
                  } else {
                    return Text('Gagal');
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        BlocBuilder<TopDestinationBloc, TopDestinationState>(
          builder: (context, state) {
            if (state is TopDestinationLoading) {
              print('Loading');
              return CircleLoading();
            }
            if (state is TopDestinationFailure) {
              print('Failure');
              return TextFailure(message: state.message);
            }
            if (state is TopDestinationLoaded) {
              List<DestinationEntity> list = state.data;
              print(list);
              return AspectRatio(
                aspectRatio: 1.5,
                child: PageView.builder(
                  controller: topDestinationController,
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destination = list[index];
                    print(list[0]);
                    return itemTopDestination(destination);
                  },
                ),
              );
            }

            return const SizedBox(height: 120);
          },
        ),
      ],
    );
  }

  Widget itemTopDestination(DestinationEntity destination) {
    final imageKey = GlobalKey();
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, AppRoute.detailDestination, arguments: destination);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: TopDestinationImage(url: URLs.image(destination.cover))),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: TextStyle(
                            height: 1, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            destination.location,
                            style:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.fiber_manual_record,
                              color: Colors.grey,
                              size: 10,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            destination.category,
                            style:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: destination.rate,
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
                        Text(
                          '(' + DMethod.numberAutoDigit(destination.rate) + ')',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.favorite_border))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  allDestination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Destination',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(height: 16),
          BlocBuilder<AllDestinationBloc, AllDestinationState>(
            builder: (context, state) {
              if (state is AllDestinationLoading) {
                print('Loading');
                return CircleLoading();
              }
              if (state is AllDestinationFailure) {
                print('Failure');
                return TextFailure(message: state.message);
              }
              if (state is AllDestinationLoaded) {
                List<DestinationEntity> list = state.data;
                print(list);
                return ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destination = list[index];
                    return itemAllDestination(context,destination);
                  },
                );
              }
      
              return const SizedBox(height: 120);
            },
          ),
        ],
      ),
    );
  }
}

Widget itemAllDestination(BuildContext context, DestinationEntity destination) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: GestureDetector(
      onTap: (){
          Navigator.pushNamed(context, AppRoute.detailDestination, arguments: destination);
        },
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start, // Rata atas
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ExtendedImage.network(
              URLs.image(destination.cover),
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
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: destination.rate,
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
                    Text(
                      '(' +
                          DMethod.numberAutoDigit(destination.rate) +
                          ') / ${NumberFormat.compact().format(destination.rateCount)}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  destination.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.grey,
                    overflow: TextOverflow.fade,
                    fontSize: 14,
                    height: 1
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
