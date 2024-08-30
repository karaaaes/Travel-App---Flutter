import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/common/app_route.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';
import 'package:travel_app/features/destination/presentation/widgets/parallax_vertical_delegate.dart';
import 'package:travel_app/features/destination/presentation/widgets/text_failure.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController editSearch = TextEditingController();

  search() {
    if (editSearch.text == '') return;
    context
        .read<SearchDestinationBloc>()
        .add(GetSearchDestinationEvent(query: editSearch.text));

    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 60, bottom: 100),
        color: Theme.of(context).primaryColor,
        child: buildSearch(),
      ),
      bottomSheet: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28), topRight: Radius.circular(28)),
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height - 200,
            child: BlocBuilder<SearchDestinationBloc, SearchDestinationState>(
                builder: (context, state) {
              if (state is SearchDestinationLoading) {
                return const CircleLoading();
              }
              if (state is SearchDestinationFailure) {
                return TextFailure(message: state.message);
              }
              if (state is SearchDestinationLoaded) {
                List<DestinationEntity> list = state.data;
                return ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destination = list[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: index == list.length ? 0 : 10),
                      child: itemSearch(destination),
                    );
                  },
                );
              }

              return Container();
            })),
      ),
    );
  }

  AspectRatio itemSearch(DestinationEntity destination) {
    final imageKey = GlobalKey();
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Builder(
            builder: (context) {
              return Flow(
                delegate: ParallaxVerticalDelegate(scrollable: Scrollable.of(context), listItemContext: context, backgroundImageKey: imageKey),
                children: [
                ExtendedImage.network(
                  key: imageKey,
                  URLs.image(destination.cover),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  handleLoadingProgress: true,
                  loadStateChanged: (state) {
                    print('Load state: ${state.extendedImageLoadState}');
                    if (state.extendedImageLoadState == LoadState.failed) {
                      print('load state error');
                      return Material(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[600],
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.black,
                        ),
                      );
                    }
              
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Material(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[600],
                        child: CircleLoading(),
                      );
                    }
              
                    return null;
                  },
                ),
              ]);
            }
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AspectRatio(
              aspectRatio: 3.8,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(destination.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text(destination.location,
                              style: TextStyle(
                                  color: Colors.grey[500]!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RatingBar.builder(
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
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.only(left: 30, right: 30, top: 12),
      child: Row(
        children: [
          IconButton.filledTonal(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 24,
              )),
          Expanded(
              child: TextField(
            controller: editSearch,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.grey[300]!,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search destination here...',
                hintStyle: TextStyle(
                  color: Colors.grey[300]!,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.all(0)),
          )),
          SizedBox(width: 10),
          IconButton.filledTonal(
              onPressed: () => this.search(),
              icon: Icon(
                Icons.search,
                size: 24,
              ))
        ],
      ),
    );
  }
}
