import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
          Text(
            'Hi, King Raka 👑',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5
            )  // Theme.of(context).textTheme.labelLarge,
            
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
          IconButton.filledTonal(onPressed: (){}, icon: Icon(
            Icons.search,
            size: 24,
          ))
        ],
      ),
    );
  }

  categories() {
    List list = [
      'Beach',
      'Lake',
      'Mountain',
      'Forest',
      'City'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(list.length, (index){
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 30 : 10,
              right: index == list.length - 1 ? 30 : 10,
              bottom: 10,
              top: 4
            ),
            child: Material(
              elevation: 4,
              color: Colors.white,
              shadowColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
    return SizedBox();
  }

  allDestination() {
    return SizedBox();
  }
}
