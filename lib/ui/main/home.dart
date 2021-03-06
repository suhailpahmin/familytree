import 'package:familytree/ui/main/business/business.dart';
import 'package:familytree/ui/main/family/family.dart';
import 'package:familytree/ui/main/lounge/lounge.dart';
import 'package:familytree/ui/main/others/other.dart';
import 'package:familytree/ui/main/pictories/pictories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Widget> _children = [
    FamilyScreen(),
    PictoriesScreen(),
    LoungeScreen(),
    BusinessScreen(),
    OthersScreen(),
  ];

  @override
  void initState() {
    tabController = TabController(length: _children.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: _children.length,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: TabBarView(
          controller: tabController,
          children: _children,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            'WAREIH',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorWeight: 2,
            indicatorColor: Colors.white,
            controller: tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.width * 0.026,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                child: Text(
                  'Pictories',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.width * 0.026,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.coffee,
                  color: Colors.white,
                ),
                child: Text(
                  'Lounge',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.width * 0.026,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
                child: Text(
                  'Business',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.width * 0.026,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                child: Text(
                  'Others',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: screenSize.width * 0.026,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
